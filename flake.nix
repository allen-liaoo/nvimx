{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tabby = {
      url = "github:nanozuki/tabby.nvim";
      flake = false;
    };
  };

  outputs = { nixpkgs, nixvim, ... }@inputs: let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    nixvimModules = rec {
      default = { 
        imports = [ ./nixvim ];
      };
      base = default;
      nix = {
        imports = [ ./nixvim ./nixvim/langs/nix.nix ];
      };
      typst = {
        imports = [ ./nixvim ./nixvim/langs/typst.nix ];
      };
    };
    forEachSystem = nixpkgs.lib.genAttrs systems;
    pkgsOf = system: nixpkgs.legacyPackages.${system};
    moduleArgs = system: (
      let 
        pkgs = pkgsOf system;
      in {
        inherit pkgs nixvim system inputs;
        inherit (pkgs) stdenv;
      }
    );
  in rec {
    inherit nixvimModules;
    makeNixvimWithModule = system: m:
      let 
        pkgs = pkgsOf system;
      in nixvim.legacyPackages.${system}.makeNixvimWithModule {
        module = m;
        extraSpecialArgs = moduleArgs system;
        inherit pkgs;
      };

    packages = forEachSystem (system: 
      let 
        pkgs = pkgsOf system;
      in pkgs.lib.mapAttrs (_: v: 
        nixvim.legacyPackages.${system}.makeNixvimWithModule {
          module = v;
          extraSpecialArgs = moduleArgs system;
          inherit pkgs;
        }
      ) nixvimModules 
    );

    devShells = forEachSystem (system: let
      pkgs = pkgsOf system;
    in {
      default = pkgs.mkShell (let
        nixvimModule = {
          imports = [ nixvimModules.nix ];
          nvimx.nixd = { # enable lsp to lookup of nixvim options
            nixpkgsName = "nixpkgs";
            flakeInputs.nixvim = "nixvimConfigurations.${system}.default";
          };
        };
        nixvimPkg = makeNixvimWithModule system nixvimModule;
      in {
        packages = [ nixvimPkg ];
      });
    });
  };
}
