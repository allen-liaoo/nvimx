# Colorscheme following the system dark/light mode
# https://github.com/f-person/auto-dark-mode.nvim
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.nvimx.colorscheme;
  # vim.o.background first, since some colorschemes pick their variant from it
  setMode = mode: colorscheme: ''
    function()
      vim.o.background = "${mode}"
      vim.cmd.colorscheme(${builtins.toJSON colorscheme})
    end
  '';
in
{
  options.nvimx.colorscheme = {
    dark = lib.mkOption {
      type = lib.types.str;
      default = "onedark";
      description = ''
        Colorscheme (`:colorscheme` name) used in dark mode. Its plugin must be installed,
        e.g. via `colorschemes.<name>` or `extraPlugins`.
      '';
    };
    light = lib.mkOption {
      type = lib.types.str;
      default = "onelight";
      description = ''
        Colorscheme (`:colorscheme` name) used in light mode. Its plugin must be installed,
        e.g. via `colorschemes.<name>` or `extraPlugins`.
      '';
    };
  };

  config = {
    extraPlugins = with pkgs.vimPlugins; [
      onedarkpro-nvim # provides onedark and onelight
      auto-dark-mode-nvim
    ];
    # dark until auto-dark-mode's (async) query answers, or if it can't (ssh, tty)
    extraConfigLuaPre = ''
      (${setMode "dark" cfg.dark})()
    '';
    # on linux, auto-dark-mode queries the xdg portal with the host's dbus-send (and
    # dbus-monitor if present), erroring without it; no dbus means no portal to query anyway
    extraConfigLua = ''
      if vim.fn.has("linux") == 0 or vim.fn.executable("dbus-send") == 1 then
        require("auto-dark-mode").setup({
          set_dark_mode = ${setMode "dark" cfg.dark},
          set_light_mode = ${setMode "light" cfg.light},
        })
      end
    '';
  };
}
