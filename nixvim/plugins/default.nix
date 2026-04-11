{ ... }:

{
  imports = [
    ./blink-cmp.nix
    ./flash.nix
    ./git-conflict.nix
    ./lualine.nix
    ./telescope.nix
    ./toggleterm.nix
    ./yazi.nix
  ];

  plugins = {
    bufferline = {
      enable = true;
      settings.options.always_show_bufferline = false;
    };

    gitsigns.enable = true;

    indent-blankline = {
      enable = true;
      settings.indent.char = "¦";
    };

    nvim-surround.enable = true;

    web-devicons = {
      enable = true;
      settings = {
        color_icons = true;
        strict = true;
      };
    };

    which-key = {
      enable = true;
      settings = {
        preset = "helix";
        win.wo.winblend = 10; # 0-100, opaque to transparent
      };
    };
  };
}
