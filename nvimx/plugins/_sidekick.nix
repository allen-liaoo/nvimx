_:

{
  plugins.sidekick = {
    enable = true;
    settings = {
      opts.nes.enabled = false;
    };
  };

  keymaps = [
    {
      mode = "n";
      action = ''<cmd>lua require("sidekick.cli").toggle({ name = "claude", focus = true })<CR>'';
      key = "<leader>at";
      options.desc = "AI: Toggle CLI";
    }
    {
      mode = [ "n" "x" ];
      action = ''<cmd>lua require("sidekick.cli").send({ msg = "{this}" })<CR>'';
      key = "<leader>as";
      options.desc = "AI: Send this (line/selection) to CLI";
    }
    {
      mode = "n";
      action = ''<cmd>lua require("sidekick.cli").send({ msg = "{file}" })<CR>'';
      key = "<leader>af";
      options.desc = "AI: Send file to CLI";
    }
    {
      mode = [ "n" "x" ];
      action = ''<cmd>lua require("sidekick.cli").prompt()<CR>'';
      key = "<leader>ap";
      options.desc = "AI: Select prompt";
    }
  ];
}
