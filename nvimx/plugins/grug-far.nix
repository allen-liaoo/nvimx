# Find and replace
# https://github.com/MagicDuck/grug-far.nvim
{
  plugins.grug-far.enable = true;
  keymaps = [{
    action = "<cmd>GrugFar<CR>";
    key = "<leader>fr";
    options.desc = "GrugFar: Search and Replace";
  }];
}

