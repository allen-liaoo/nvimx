{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.nvimx.dap.enable = lib.mkEnableOption "dap";

  config = lib.mkIf (config.nvimx.dap.enable) {
    plugins.dap.enable = true;
    plugins.dap-ui.enable = true;

    # supports C/C++/Rust
    plugins.dap-lldb = {
      settings.codelldb_path = lib.getExe' pkgs.vscode-extensions.vadimcn.vscode-lldb.adapter "codelldb";
    };
  };
}
