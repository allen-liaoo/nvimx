# oil.nvim, with column view
# https://github.com/allen-liaoo/coil.nvim
{
  plugins.oil = {
    enable = true;
    settings = {
      columns  = [ "icon" "permissions" ];
      delete_to_trash = true;
      default_file_explorer = true;
    };
  };

  # coil module imported in flake.nix
  plugins.coil.enable = true;

  keymaps = [
    {
      action = "<cmd>Coil<CR>";
      key = "<leader>]";
      mode = [ "n" ];
      options.desc = "Coil: Open column view";
    }
  ];
}
