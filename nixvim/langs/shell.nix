{
  lib,
  config,
  ...
}:

{
  options.nvimx.shell.enable = lib.mkEnableOption "shell";
  config = lib.mkIf (config.nvimx.shell.enable) {
    nvimx.lsp.enable = true;
    lsp.servers.bashls.enable = true;

    nvimx.treesitter.enable = true;
    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      bash
      zsh
      fish
    ];
  };
}
