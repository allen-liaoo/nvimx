{
  pkgs,
  nixvim,
  system,
  lib,
  stdenv,
  ...
}:

(nixvim.legacyPackages.${system}.makeNixvimWithModule {
  inherit pkgs;
  module = {
    clipboard = {
      providers = {
        wl-copy.enable = lib.strings.hasPrefix "linux" stdenv.hostPlatform.system;
      };
    };
  };
})
