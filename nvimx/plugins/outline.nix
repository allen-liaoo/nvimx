_:

{
  plugins.aerial = {
    enable = true;
    settings = {
      backends = [ "treesitter" "lsp" "markdown" "man" ];
    };
  };

  keymaps = [{
    action = "<cmd>AerialToggle<CR>";
    key = "<leader>o";
    options.desc = "Aerial: Toggle symbol outline";
  }];
}
