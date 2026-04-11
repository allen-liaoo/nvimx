_:

{
  imports = [ ./lsp.nix ];

  lsp.servers.nixd = {
    enable = true;
    activate = true;
  };
}
