{
  lib,
  pkgs,
  config,
  ...
}:

let
  tree-sitter-egglog = pkgs.callPackage ../../pkgs/tree-sitter-egglog.nix { };
in
{
  options.nvimx.preset.egglog = {
    enable = lib.mkEnableOption "egglog";
  };

  config = lib.mkIf (config.nvimx.preset.egglog.enable) {
    plugins.treesitter = {
      grammarPackages = [ tree-sitter-egglog ];
    };
    filetype.extension.egg = "egglog";
  };
}

