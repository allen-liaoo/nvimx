{
  lib,
  config,
  ...
}:

{
  options.nvimx = {
    lsp.enable = lib.mkEnableOption "lsp";
    treesitter.enable = lib.mkEnableOption "treesitter";
  };

  imports = [
    ./lua.nix
    ./nix.nix
    ./shell.nix
    ./typst.nix
  ];

  config = lib.mkIf (config.nvimx.lsp.enable) {
    lsp = {
      inlayHints.enable = true;
      servers."*" = {
        config = {
          capabilities = {
            textDocument = {
              semanticTokens = {
                multilineTokenSupport = true;
              };
            };
          };
          root_markers = [
            ".git"
          ];
        };
      };
  
    };
    plugins.lspconfig.enable = true;

 } // lib.mkIf (config.nvimx.treesitter.enable) { 
    plugins.treesitter = {
      enable = true;
      highlight.enable = true;
      indent.enable = true;
      folding.enable = true;
      nixGrammars = true;
      nixvimInjections = true;
    };

    opts = {
      foldlevel = 99;
      foldlevelstart = 90;
    };
  
    plugins.treesitter-context = {
      enable = true;
    };
  };
}
