{ ... }:

{
  plugins.yazi = {
    enable = true;
    settings = {
      enable_mouse_support = true;
      floating_window_scaling_factor = 0.75;
      open_for_directories = true;
    };
  };

  keymaps = [
    {
      action = "<cmd>Yazi<CR>";
      key = "<leader>-";
      mode = [ "n" "i" "x" "s" ];
      options.desc = "Yazi: Open files";
    }
  ];
}
