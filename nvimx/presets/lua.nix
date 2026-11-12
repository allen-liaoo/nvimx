{
  lib,
  config,
  ...
}:

{
  options.nvimx.preset.lua.enable = lib.mkEnableOption "lua";
  config = lib.mkIf (config.nvimx.preset.lua.enable) {
    lsp.servers.lua_ls.enable = true;

    # Neovim lua API completion/types for lua_ls
    plugins.lazydev.enable = true;
    plugins.blink-cmp.settings.sources = {
      default = [ "lazydev" ];
      providers.lazydev = {
        name = "LazyDev";
        module = "lazydev.integrations.blink";
        score_offset = 100;
      };
    };

    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      lua
      luadoc
    ];
  };
}
