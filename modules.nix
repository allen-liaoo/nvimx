rec {
  default = { 
    imports = [ ./nixvim ];
  };
  base = default;
  configs = base // {
    nvimx.configs.enable = true;
  };
  nix = base // {
    nvimx.nix.enable = true;
  };
  shells = base // {
    nvimx.shells.enable = true;
  };
  typst = base // {
    nvimx.typst.enable = true;
  };
}
