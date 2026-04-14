{
  lib,
  config,
  ...
}:

{
  options.nvimx.lua.enable = lib.mkEnableOption "lua";
  config = lib.mkIf (config.nvimx.lua.enable) {
    nvimx.lsp.enable = true;
    lsp.servers.lua_ls.enable = true;

    nvimx.treesitter.enable = true;
    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      lua
    ];
  };
}
