_:

{
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
}
