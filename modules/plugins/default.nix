{ ... }:

{
  imports = [
    ./yazi.nix
  ];

  plugins = {
    bufferline.enable = true;

    cursorline.enable = true;

    gitsigns.enable = true;

    indent-blankline = {
      enable = true;
      settings.indent.char = "¦";
    };

    lualine = {
      enable = true;
      settings = {
        options = {
          globalstatus = true; # one status line at the bottom
        };
      };
    };

    nvim-surround.enable = true;

    web-devicons = {
      enable = true;
      settings = {
        color_icons = true;
        strict = true;
      };
    };
  };
}
