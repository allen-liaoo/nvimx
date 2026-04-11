_:

{
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        globalstatus = true; # one status line at the bottom
      };
      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [ "branch" "diff" "diagnostics" ];
        lualine_c = [ "filename" ];
        lualine_x = [ "lsp_status" "filetype" ];
        lualine_y = [ "progress" ];
        lualine_z = [ "location" ];
      };
    };
  };
}
