_:

{
  keymaps = [
    # buffer
    {
      key = "<C-h>";
      action = "<cmd>bprevious<CR>";
      options.desc = "Buffer: Previous";
    }
    {
      key = "<C-l>";
      action = "<cmd>bnext<CR>";
      options.desc = "Buffer: Next";
    }
    {
      key = "<C-x>";
      action = "<cmd>bdelete<CR>";
      options.desc = "Buffer: Close";
    }
    # window
    {
      key = "<leader>v";
      action = "<cmd>vsplit<CR>";
      options.desc = "Window: Vertical split";
    }
    {
      key = "<leader>h";
      action = "<cmd>split<CR>";
      options.desc = "Window: Horizontal split";
    }
  ];
}
