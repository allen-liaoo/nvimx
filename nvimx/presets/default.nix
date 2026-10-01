_:

{
  imports = [
    ./configs.nix
    ./egglog.nix
    ./java.nix
    ./latex.nix
    ./nix.nix
    ./rust.nix
    ./shells.nix
    ./typst.nix
  ];
  config = {
    nvimx.lsp.enable = true;
  };
}
