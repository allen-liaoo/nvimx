_:

{
  imports = [ ./lsp.nix ];

  lsp.servers.tinymist = {
    enable = true;
    activate = true;
  };
}
