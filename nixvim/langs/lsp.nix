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

    keymaps = [
      {
        key = "gd";
        lspBufAction = "definition";
        options.desc = "LSP: Go to definition";
      }
      {
        key = "gD";
        lspBufAction = "references";
        options.desc = "LSP: Go to references";
      }
      {
        key = "gt";
        lspBufAction = "type_definition";
        options.desc = "LSP: Go to type definition";
      }
      {
        key = "gi";
        lspBufAction = "implementation";
        options.desc = "LSP: Go to implementation";
      }
      {
        key = "K";
        lspBufAction = "hover";
      }
    ];
  };
  plugins.lspconfig.enable = true;
}
