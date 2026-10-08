# Scrollbar
# https://github.com/dstein64/nvim-scrollview/
{
  config,
  lib,
  ...
}:

{
  plugins.scrollview = {
    enable = true;
    settings = {
      signs_on_startup = [
        "conflicts"
        "cursor"
        "diagnostics"
        "folds"
        "marks"
        "search"
      ];
      # draw signs on top of the scrollbar instead of beside it
      signs_scrollbar_overlap = "over";
      signs_max_per_row = 2;
      diagnostics_severities = [ (lib.nixvim.mkRaw "vim.diagnostic.severity.ERROR") ];
    };
  };

  # after gitsigns.setup(), which runs before extraConfigLua
  extraConfigLua = lib.mkIf config.plugins.gitsigns.enable ''
    require('scrollview.contrib.gitsigns').setup({
      add_symbol = '▏',
      change_symbol = '▏',
      delete_symbol = '-',
      
      add_priority = 20,
      change_priority = 20,
      delete_priority = 20,
    })
  '';
}
