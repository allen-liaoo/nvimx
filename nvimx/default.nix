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
    ./keys
    ./plugins
    ./presets

    ./dap.nix
    ./lsp.nix
    ./treesitter.nix
  ];
  enableMan = false;

  colorschemes.onedark = {
    enable = true;
    settings = {
      style = "cool";
    };
  };

  globals = {
    mapleader = "\\"; # enter
  };

  opts = {
    mouse = "a"; # mouse support: all modes
    mousemodel = "extend"; # mouse selection
    number = true; # lineno
    cursorline = true;
    termguicolors = true;
    relativenumber = true;

    # indent
    tabstop = 2;
    shiftwidth = 2;
    softtabstop = 2;
    expandtab = true;
    smartindent = true;
  };

  extraConfigLua = ''
    vim.api.nvim_set_hl(0, "DiffChange", {}) -- remove line highlights for changed lines in diff
  '';

  clipboard = {
    # register = "unnamedplus"; # manually write yank to system clipboard (and ignore delete ops)
  };
}
