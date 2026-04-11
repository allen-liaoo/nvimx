_:

{
  imports = [ ./lsp.nix ];

  lsp.servers.nixd = {
    enable = true;
    activate = true;
    settings.nixd = {
      diagnostic.suppress = [ "sema-extra-with" ];
    };
  };
}
