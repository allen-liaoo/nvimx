{ pkgs, ... }:

{
  extraPackages = [ pkgs.claude-agent-acp ];

  plugins.codecompanion = {
    enable = true;
    settings = {
      interactions = {
        chat.adapter = "claude_code"; # requires the env var CLAUDE_CODE_OAUTH_TOKEN to be set
        inline.adapter = "claude_code";
      };
    };
  };

  keymaps = [
    {
      mode = [ "n" "v" ];
      action = "<cmd>CodeCompanionChat Toggle<CR>";
      key = "<leader>ac";
      options.desc = "AI: Toggle chat";
    }
    {
      mode = [ "n" "v" ];
      action = "<cmd>CodeCompanionActions<CR>";
      key = "<leader>aa";
      options.desc = "AI: Action palette";
    }
    {
      mode = "v";
      action = "<cmd>CodeCompanionChat Add<CR>";
      key = "<leader>ax";
      options.desc = "AI: Add selection to chat";
    }
  ];
}
