rec {
  default = { 
    imports = [ ./nixvim ];
  };
  base = default;
  nix = base // {
    nvimx.nix.enable = true;
  };
  shell = base // {
    nvimx.shell.enable = true;
  };
  typst = base // {
    nvimx.typst.enable = true;
  };
}
