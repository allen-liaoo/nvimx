{
  lib,
  pkgs,
  config,
  ...
}:

let
  java-debug-server = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server";
in
{
  options.nvimx.preset.java.enable = lib.mkEnableOption "java";
  config = lib.mkIf (config.nvimx.preset.java.enable) {
    lsp.servers.jdtls = {
      enable = true;
      activate = true;
    };

    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      java
    ];

    # nvim-jdtls hooks into the jdtls client on attach and registers the java dap adapter,
    # discovering main classes as debug configurations
    nvimx.dap.enable = true;
    plugins.jdtls = {
      enable = true;
      settings.init_options.bundles.__raw = ''
        vim.fn.glob("${java-debug-server}/com.microsoft.java.debug.plugin-*.jar", true, true)
      '';
    };

    # static fallbacks
    plugins.dap.configurations.java = [
      {
        type = "java";
        request = "launch";
        name = "Launch current file";
      }
      {
        type = "java";
        request = "attach";
        name = "Attach (127.0.0.1:5005)";
        hostName = "127.0.0.1";
        port = 5005;
      }
    ];
  };
}
