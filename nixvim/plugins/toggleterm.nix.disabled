_:

{
  plugins.toggleterm = {
    enable = true;
    settings = {
      size = ''
        function(term)
          if term.direction == "horizontal" then
            return vim.o.lines * 0.3
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end
      '';
    };
  };

  extraConfigLua = ''
    vim.api.nvim_create_user_command("TermBuf", function()
      vim.cmd("enew")
      vim.cmd("terminal")
      vim.api.nvim_buf_set_name(0, "terminal://" .. vim.api.nvim_get_current_buf())
    end, {})
    
    vim.api.nvim_create_autocmd("TermOpen", {
      callback = function()
        vim.cmd("startinsert")
      end,
    })
  '';

  keymaps = [
    {
      action = "<cmd>TermBuf<CR>";
      key = "<leader>tt";
      mode = [ "n" "i" "x" "s" ];
      options.desc = "Terminal: Open in new tab";
    }
    {
      action = "<cmd>ToggleTerm direction=horizontal<CR>";
      key = "<leader>th";
      mode = [ "n" "i" "x" "s" ];
      options.desc = "Terminal: Toggle horizontal";
    }
    {
      action = "<cmd>ToggleTerm direction=vertical<CR>";
      key = "<leader>tv";
      mode = [ "n" "i" "x" "s" ];
      options.desc = "Terminal: Toggle vertical";
    }
    # keymaps in terminal mode
    {
      action = "<C-\\><C-n>";
      key = "<esc>";
      mode = [ "t" ];
      options.desc = "Escape terminal";
    }
    {
      action = "<C-w>";
      key = "<C-\\><C-n><C-w>";
      mode = [ "t" ];
      options.desc = "Use window commands as normal";
    }
  ];
}
