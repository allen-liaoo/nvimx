# `n`v`i`m`x`

Project based, modular Neovim configuration via NixVim.

Nvimx exports these module/package variants:
- `default`/`base` - Base Neovim instance, contains most plugins, no specific language support. All other variants automatically includes this base.
- Languages:
  - `nix` - [nixd](https://github.com/nix-community/nixd/)
  - `typst` - [Tinymist](https://github.com/Myriad-Dreamin/tinymist)

## Usage
1. Use a packaged variant (i.e. via `nix shell`):
```bash
nix shell github:allen-liaoo/nvimx#{variant}
```

2. Construct a module in a flake (i.e. in `devShells`).
Nvimx flake outputs `nixvimModules.${variant}` and `makeNixvimWithModule (system: nixvimModule: ...)` to be used in this case. 
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvimx = {
      url = "github:allen-liaoo/nvimx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixvim }: let
  in {
    devShells = let 
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in ${system}.default = pkgs.mkShell (let
      nixvimModule = {
        # enable the variants you want to use
        nvimx.typst.enable = true;

        # or add custom nixvim or nvimx options here
        plugins.xyz.enable = true;
      };
      nixvimPkg = nvimx.makeNixvimWithModule system nixvimModule; # package it!
    in {
      packages = [ nixvimPkg ];
    });
  };
}
```

## Credits
Inspired by [ar-at-localhost/np](https://github.com/ar-at-localhost/np).
