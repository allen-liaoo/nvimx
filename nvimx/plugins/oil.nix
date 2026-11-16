# oil.nvim, with column view
# https://github.com/stevearc/oil.nvim
# https://github.com/allen-liaoo/coil.nvim
{
  pkgs,
  ...
}:

{
  plugins.oil = {
    enable = true;
    settings = {
      default_file_explorer = true;
      columns  = [ "icon" "permissions" ];
      use_default_keymaps = false;
      keymaps = {
        "g?" = { __unkeyed-1 = "actions.show_help"; mode = "n"; };
        "<CR>" = { __unkeyed-1 = "actions.select"; };
        "<C-v>" = { __unkeyed-1 = "actions.select"; opts.vertical = true; };
        "<C-H>" = { __unkeyed-1 = "actions.select"; opts.horizontal = true; };
        "<C-t>" = { __unkeyed-1 = "actions.select"; opts.tab = true; };
        "<C-p>" = { __unkeyed-1 = "actions.preview"; };
        "<C-c>" = { __unkeyed-1 = "actions.close"; mode = "n"; };
        "<C-l>" = { __unkeyed-1 =  "actions.refresh"; };
        "-" = { __unkeyed-1 = "actions.parent"; mode = "n"; };
        "_" = { __unkeyed-1 = "actions.open_cwd"; mode = "n"; };
        "`" = { __unkeyed-1 = "actions.cd"; mode = "n"; };
        "g~" = { __unkeyed-1 = "actions.cd"; opts.scope = "tab"; mode = "n"; };
        "gs" = { __unkeyed-1 = "actions.change_sort"; mode = "n"; };
        "gx" = { __unkeyed-1 = "actions.open_external"; };
        "g." = { __unkeyed-1 = "actions.toggle_hidden"; mode = "n"; };
        "g\\" = { __unkeyed-1 = "actions.toggle_trash"; mode = "n"; };
        "gd" = {
          desc = "Toggle detailed column view";
          callback.__raw = ''function()
            -- see luaConfig.pre
            oil_detail = not oil_detail
            if oil_detail then
              require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
            else
              require("oil").set_columns({ "icon", "permissions" })
            end
          end'';
        };
      };
      delete_to_trash = true;
      watch_for_changes = true;
      # Return true to automatically git add/mv/rm files
      git = {
        mv.__raw = ''function(src_path, dest_path)
          return true
        end'';
        rm.__raw = ''function(path)
          return true
        end'';
      };
      # for oil-git-status
      win_options = {
        signcolumn = "yes:2";
      };
      standalone = {
        edit_here = true;
      };
    };
    # See keymap to toggle detailed column view
    luaConfig.pre = ''
      local oil_detail = false
    '';
  };

  plugins.oil-git-status.enable = true;

  extraPlugins = [
    pkgs.vimPlugins.oil-lsp-diagnostics-nvim
  ];
  extraConfigLua = ''
    require('oil-lsp-diagnostics').setup({});
  '';

  # coil module imported in flake.nix
  plugins.coil = {
    enable = true;
    settings = {
      open_external = true;
      edit_here = true;
      standalone = {
        open_external = true;
        edit_here = true;
      };
    };
  };

  keymaps = [
    {
      action = "<cmd>Coil<CR>";
      key = "<leader>]";
      mode = [ "n" ];
      options.desc = "Coil: Open column view";
    }
  ];
}
