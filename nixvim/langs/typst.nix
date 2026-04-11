_:

{
  imports = [ ./lsp.nix ];

  lsp.servers.tinymist = {
    enable = true;
    activate = true;
  };

  dependencies.typst = {
    enable = true;
    packageFallback = true; # let local version override this
  };
}
