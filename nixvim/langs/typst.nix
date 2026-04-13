{
  lib,
  config,
  ...
}:

{
  options.nvimx.typst.enable = lib.mkEnableOption "typst";
  config = lib.mkIf (config.nvimx.typst.enable) {
    nvimx.lsp.enable = true;

    lsp.servers.tinymist = {
      enable = true;
      activate = true;
    };

    nvimx.treesitter.enable = true;

    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      typst
    ];
  
    dependencies.typst = {
      enable = true;
      packageFallback = true; # let local version override this
    };
  };
}
