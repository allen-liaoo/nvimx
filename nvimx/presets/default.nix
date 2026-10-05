_:

{
  imports = [
    ./c.nix
    ./configs.nix
    ./egglog.nix
    ./java.nix
    ./latex.nix
    ./llvm-ir.nix
    ./markdown.nix
    ./nix.nix
    ./rust.nix
    ./shells.nix
    ./typst.nix
  ];
  config = {
    nvimx.lsp.enable = true;
  };
}
