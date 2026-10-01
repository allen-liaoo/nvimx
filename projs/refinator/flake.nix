{
  description = "Refinator research";
  inputs = {
    nvimx.url = "path:../..";            # the parent nvimx flake, same commit
    nixpkgs.follows = "nvimx/nixpkgs";
  };

  outputs = { nixpkgs, nvimx, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ];
    in {
      packages = forAllSystems (system: {
        default = nvimx.makeNvimxWithModule system {
          nvimx.preset.rust.enable = true;
          nvimx.preset.llvm-ir.enable = true;
          nvimx.preset.c.enable = true;
          nvimx.preset.egglog.enable = true;
        };
      });

      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShellNoCC {
          packages = [ nvimx.packages.${system}.default or null ];
        };
      });
    };
}
