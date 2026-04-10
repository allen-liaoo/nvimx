_:

{
  keymaps = [
    {
      key = "<C-h>";
      action = "<cmd>bprevious<CR>";
      options.desc = "Go to previous buffer";
    }
    {
      key = "<C-l>";
      action = "<cmd>bnext<CR>";
      options.desc = "Go to next buffer";
    }
    {
      key = "<C-x>";
      action = "<cmd>bdelete<CR>";
      options.desc = "Close buffer";
    }
  ];
}
