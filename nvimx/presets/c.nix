{
  lib,
  config,
  ...
}:

{
  options.nvimx.preset.c.enable = lib.mkEnableOption "c";
  config = lib.mkIf (config.nvimx.preset.c.enable) {
    lsp.servers.ccls = {
      enable = true;
    };

    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      c
    ];
  };
}
