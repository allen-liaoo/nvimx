{
  lib,
  config,
  ...
}:

{
  options.nvimx.preset.java.enable = lib.mkEnableOption "java";
  config = lib.mkIf (config.nvimx.preset.java.enable) {
    lsp.servers.jdtls = {
      enable = true;
      activate = true;
    };

    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      java
    ];
  };
}
