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
    ./plugins.nix
  ];
  enableMan = false;
  colorschemes.one = {
    enable = true;
    settings = {
      style = "darker";
    };
  };

  opts = {
    mouse = "a"; # mouse support: all modes
    mousemodel = "extend"; # mouse selection
    clipboard = "unnamedplus"; # y, p integrate w system clipboard
    number = true; # lineno
    relativenumber = true;
    termguicolors = true;
    # indent
    tabstop = 2;
    shiftwidth = 2;
    softtabstop = 2;
    expandtab = true;
    smartindent = true;
  };

  clipboard = {
    providers = {
      wl-copy.enable = lib.strings.hasPrefix "linux" stdenv.hostPlatform.system;
    };
  };
 }
