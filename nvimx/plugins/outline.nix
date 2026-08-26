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

  extraConfigLua = ''
    -- name the aerial sidebar buffer after its source buffer, instead of [No Name]
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "aerial",
      desc = "Aerial: name outline buffer after its source buffer",
      callback = function(args)
        local source_bufnr = vim.b[args.buf].source_buffer
        if not source_bufnr then
          return
        end
        local source_name = vim.api.nvim_buf_get_name(source_bufnr)
        if source_name == "" then
          return
        end
        pcall(vim.api.nvim_buf_set_name, args.buf, "Outline: " .. vim.fn.fnamemodify(source_name, ":t"))
      end,
    })
  '';
}
