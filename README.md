# `n`v`i`m`x`

Project-based, modular Neovim configuration via NixVim.

Nvimx provides many presets based on different language (lsp, treesitter) support and different uses, allowing you to choose what is installed on a neovim instance per project. Works well with [direnv](https://direnv.net/).

Nvimx exports different module/package presets:
- `default`/`base` - Base Neovim instance, contains all plugins, no language support. All other presets automatically includes this base.
- Language-based - See the end of this readme.

Additionally, you can set `nvimx.treesitter.enableAllGrammars = true` to get ts for all languages without individually enabling variants.

## Usage
1. Run directly:
```bash
nix run github:allen-liaoo/nvimx
```
You can run a preset by appending `#{preset}`.

You may need to enable experimental features by passing in this environment variable:
```
NIX_CONFIG="extra-experimental-featues = nix-command flakes"
```

2. Construct a module in a flake (i.e. in `devShells`).
Nvimx flake outputs `makeNvimxWithModule (system: nvimxModule: ...)` to be used in this case. Presents have options under `nvimx.preset.${preset}`, and need to be opted in with `nvimx.preset.${preset}.enable = true`.
```nix
{
  outputs = { self, nixpkgs, nixvim }: let
  in {
    devShells = let 
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in ${system}.default = pkgs.mkShell (let
      nixvimModule = {
        # enable the presets you want to use
        nvimx.preset.typst.enable = true;

        # or add custom nixvim or nvimx options here
        plugins.xyz.enable = true;
      };
      nixvimPkg = nvimx.makeNvimxWithModule system nixvimModule; # package it!
    in {
      packages = [ nixvimPkg ];
    });
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvimx = {
      url = "github:allen-liaoo/nvimx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
```
For more examples, see the [projs/](/projs) directory.

## Presets
  | Preset | Languages | TreeSitter | LSP | DAP |
  | --- | --- | :-: | --- | --- |
  | `c` | C | ✅ | [ccls](https://github.com/MaskRay/ccls) | [dap-lldb](https://github.com/julianolf/nvim-dap-lldb/) |
  | `configs` | ini, json, kdl, toml, yaml | ✅ | — | — | 
  | `egglog` | egglog | ✅* | — | — |
  | `java` | Java | ✅ | [jdtls](https://github.com/eclipse-jdtls/eclipse.jdt.ls) | [java-debug](https://github.com/microsoft/java-debug) via jdtls |
  | `latex` | LaTeX | ✅ | [texlab](https://github.com/latex-lsp/texlab) | — | 
  | `llvm-ir` | LLVM IR | ✅ | [llvm-ir-lsp](https://github.com/indoorvivants/llvm-ir-lsp)* | — |
  | `markdown`** | Markdown | ✅ | [marksman](https://github.com/artempyanykh/marksman) | — | 
  | `nix` | Nix | ✅ | [nixd](https://github.com/nix-community/nixd/) | — |
  | `rust` | Rust | ✅ | [rust-analyzer](https://github.com/rust-lang/rust-analyzer) | [dap-lldb](https://github.com/julianolf/nvim-dap-lldb/) |
  | `shells` | bash, fish, zsh | ✅ | [bashls](https://github.com/bash-lsp/bash-language-server) (bash only) | — |
  | `typst` | Typst | ✅ | [tinymist](https://github.com/Myriad-Dreamin/tinymist) | — | 

*: Manually packaged here (Not in `neovim-treesitter` or `nixvim` lsps)  
**: Enabled by default

## Credits
Inspired by [ar-at-localhost/np](https://github.com/ar-at-localhost/np).

