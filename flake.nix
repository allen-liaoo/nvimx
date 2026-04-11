{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixvim }: let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    forEachSystem = nixpkgs.lib.genAttrs systems;
  in {
    packages = forEachSystem (system: 
      let 
        pkgs = nixpkgs.legacyPackages.${system};
        args = {
          inherit pkgs nixvim system;
          inherit (pkgs) stdenv;
        };
      in rec {
        default = { 
          imports = [ ./modules ];
        };
        base = default;
        nix = {
          imports = [ ./modules ./modules/langs/nix.nix ];
        };
        typst = {
          imports = [ ./modules ./modules/langs/typst.nix ];
        };
      }
      |> pkgs.lib.mapAttrs (_: v: nixvim.legacyPackages.${system}.makeNixvimWithModule {
        module = v;
        extraSpecialArgs = args;
        inherit pkgs;
      })
    );
  };
}
