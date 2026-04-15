{
  nixvim,
  ...
}:

{
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        globalstatus = true; # one status line at the bottom
      };
      sections = {
        lualine_a = [
          {
            __unkeyed-1 = "filename"; 
            symbols = {
              modified = "[+]";
              readonly = "[-]";
              unamed = "[No Name]";
              new = "[New]";
            };
          }
        ];
        lualine_b = [ "filetype" ];
        lualine_c = [ "lsp_status" "diagnostics" ];
        lualine_x = [ "progress" ];
        lualine_y = [ 
          # use gitsigns branch and diff
          {
            __unkeyed-1 = "diff";
            source.__raw = "diff_source";
          }
          {
            __unkeyed-1 = "b:gitsigns_head";
            icon = { __unkeyed-1 = ""; align = "right"; };
          }
        ];
        lualine_z = [ "mode" ];
      };
    };

    luaConfig.pre = ''
      local function diff_source()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
          return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed
          }
        end
      end
    '';
  };
}
