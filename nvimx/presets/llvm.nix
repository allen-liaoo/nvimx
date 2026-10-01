{
  lib,
  pkgs,
  config,
  ...
}:

let
  llvm-ir-lsp = pkgs.callPackage ../../pkgs/llvm-ir-lsp.nix { };
in
{
  options.nvimx.preset.llvm = {
    enable = lib.mkEnableOption "llvm";
  };

  config = lib.mkIf (config.nvimx.preset.llvm.enable) {
    lsp.servers.llvm_ir_lsp = {
      enable = true;
      activate = true;
      config = {
        cmd = [ (lib.getExe llvm-ir-lsp) ];
        filetypes = [ "llvm" ];
      };
    };

    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      llvm
    ];
    filetype.extension.ll = "llvm";
  };
}
