{
  pkgs,
  nixvim,
  system,
  stdenv,
  ...
}@args:

(nixvim.legacyPackages.${system}.makeNixvimWithModule {
  inherit pkgs;
  module = {
    imports = [
      ./modules
    ];
  };
  extraSpecialArgs = args;
})
