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
      config = {
        cmd = [ "tinymist" ];
        filetypes = [ "typst" ];
        settings = {
          outputPath = "$dir/$name";
          exportPdf = "onType";
        };
      };
    };

    dependencies.tinymist = {
      enable = true;
      packageFallback = true; # let local version override this
    };

    nvimx.treesitter.enable = true;

    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      typst
    ];
  };
}
