_:

{
  plugins.flash = {
    enable = true;
    settings = {
      #modes.search.enabled = true # enable jump labels in built-in search via /
    };
  };
  keymaps = [
    { # search with jump labels
      action = "<cmd>lua (function() require('flash').jump() end)()<CR>";
      key = "s";
      mode = [ "n" "x" "o" ];
      options.desc = "Flash jump";
    }
    { # toggle jump labels during search
      action = "<cmd>lua (function() require('flash').toggle() end)()<CR>";
      key = "<C-s>";
      mode = [ "c" ];
      options.desc = "Toggle Flash search";
    }
  ];
}
