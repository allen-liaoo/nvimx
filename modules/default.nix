{
  pkgs,
  nixvim,
  system,
  lib,
  stdenv,
  ...
}:

{
  imports = [
    ./lsp.nix
    ./plugins
  ];
  enableMan = false;

  colorschemes.onedark = {
    enable = true;
    settings = {
      style = "cool";
    };
  };

  globals = {
    mapleader = ",";
  };

  opts = {
    mouse = "a"; # mouse support: all modes
    mousemodel = "extend"; # mouse selection
    number = true; # lineno
    termguicolors = true;
    # indent
    tabstop = 2;
    shiftwidth = 2;
    softtabstop = 2;
    expandtab = true;
    smartindent = true;
  };

  clipboard = {
    register = "unnamedplus"; # y, p integrate w system clipboard
    providers = {
      wl-copy.enable = lib.strings.hasPrefix "linux" stdenv.hostPlatform.system;
    };
  };
}
