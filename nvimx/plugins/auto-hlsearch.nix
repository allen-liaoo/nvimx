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
