{
  description = "Project-based, modular Neovim configuration via NixVim.";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim"; # Dont follow nixpkgs; see: https://nix-community.github.io/nixvim/user-guide/faq.html#how-do-i-solve-name-cannot-be-found-in-pkgs
      inputs.nixpkgs.follows = "nixpkgs";
    };
    winresize = {
      url = "github:pogyomo/winresize.nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixvim, ... }@inputs: let
    nixvimModules = import ./presets.nix;
    forAllSystems = with nixpkgs.lib; genAttrs platforms.all;
    pkgsOf = system: import nixpkgs { inherit system; config.allowUnfree = true; };
    moduleArgs = system: (
      let 
        pkgs = pkgsOf system;
      in {
        inherit nixvim system inputs;
        inherit (pkgs) stdenv;
      }
    );
  in {
    inherit nixvimModules;
    makeNvimxWithModule = system: m:
      nixvim.legacyPackages.${system}.makeNixvimWithModule {
        pkgs = pkgsOf system;
        module = [
          m
          (import ./nvimx)
          { _module.args = moduleArgs system; }
        ];
      };
    
    apps = forAllSystems (system: nixpkgs.lib.mapAttrs (_: pkg: {
        type = "app";
        program = "${pkg}/bin/nvim";
      }) self.packages.${system});

    packages = forAllSystems (system: 
      nixpkgs.lib.mapAttrs (_: self.makeNvimxWithModule system) nixvimModules);

    devShells = forAllSystems (system: let
      pkgs = pkgsOf system;
    in {
      default = pkgs.mkShell (let
        nixvimModule = {
          nvimx.preset.nix.enable = true;
          nvimx.preset.nix.nixd = { # enable lsp to lookup of nixvim options
            nixpkgsName = "nixpkgs";
            flakeInputs.nixvim = "nixvimConfigurations.${system}.default";
          };
        };
        nixvimPkg = self.makeNvimxWithModule system nixvimModule;
        nvimx-update = pkgs.writeShellApplication {
          name = "nvimx-update";
          runtimeInputs = [ pkgs.git pkgs.nix pkgs.coreutils ];
          text = ''
            shopt -s nullglob
            cd "$(git rev-parse --show-toplevel)"

            nix flake update                                  # bump the root's inputs

            for f in projs/*/flake.nix; do
              dir=$(dirname "$f")
              echo "re-locking $dir"
              nix flake update nvimx --flake "./$dir"         # re-sync nvimx + its transitive pins
            done
          '';
        };
      in {
        packages = [ nixvimPkg nvimx-update ];
      });
    });
  };
}
