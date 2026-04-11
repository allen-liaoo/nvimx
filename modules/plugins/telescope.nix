_:

{
  plugins.telescope = {
    enable = true;
    extensions = {
      fzf-native.enable = true;
    };

    keymaps = {
      "<leader>ff" = {
        action = "find_files";
        options.desc = "Telescope: Find files";
      };

      "<leader>fg" = {
        action = "live_grep";
        options.desc = "Telescope: Find in directory";
      };

      "<leader>fw" = {
        action = "grep_string";
        options.desc = "Telescope: Find in file";
      };

      "<leader>fc" = {
        action = "commands";
        options.desc = "Telescope: Find commands";
      };

      "<leader>fk" = {
        action = "keymaps";
        options.desc = "Telescope: Find keymaps";
      };
    };
  };

  dependencies.ripgrep.enable = true;
}
