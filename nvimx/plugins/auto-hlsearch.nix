# Automatically remove search highlight
# https://github.com/asiryk/auto-hlsearch.nvim
{
  pkgs,
  ...
}:

{
  extraPlugins = [pkgs.vimPlugins.auto-hlsearch-nvim];
  extraConfigLua = ''
    require("auto-hlsearch").setup()
  '';
}
