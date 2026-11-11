# Note taking with neorg
# https://github.com/nvim-neorg/neorg
{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.nvimx.preset.neorg.enable = lib.mkEnableOption "neorg";

  config = lib.mkIf (config.nvimx.preset.neorg.enable) {
    # the norg treesitter parsers are bundled with the nixpkgs neorg package
    plugins.neorg = {
      enable = true;
      # failed edits (e.g. E37 on a modified buffer) call :format on log.error's nil return
      # TODO: remove when fixed
      package = pkgs.vimPlugins.neorg.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
          substituteInPlace lua/neorg/modules/core/dirman/utils/module.lua \
            --replace-fail 'log.error("Failed to edit file %s. Error:\n%s"):format(path, err)' \
                           'log.error(("Failed to edit file %s. Error:\n%s"):format(path, err))'
        '';
      });
      telescopeIntegration = {
        enable = true;
        # search_headings uses nvim-treesitter master APIs, gone on main
        # TODO: remove when fixed
        package = pkgs.vimPlugins.neorg-telescope.overrideAttrs {
          postPatch = ''
            substituteInPlace lua/telescope/_extensions/neorg/search_headings.lua \
              --replace-fail 'ts_parsers.ft_to_lang(filetype)' 'vim.treesitter.language.get_lang(filetype) or filetype' \
              --replace-fail 'ts_configs.is_enabled("highlight", filetype, opts.bufnr)' 'vim.treesitter.highlighter.active[opts.bufnr] ~= nil'
          '';
        };
      };
      # load modules with default config with .__empty = null ({} in lua)
      settings.load = {
        "core.defaults".config.disable = [
          # notes only: no journaling, dates, calendar or todos
          "core.journal"
          "core.tempus"
          "core.ui.calendar"
          "core.qol.todo_items"
          "core.todo-introspector"
        ];
        "core.concealer".__empty = null;
        "core.dirman".config = {
          workspaces = lib.mkDefault { notes = "~/notes"; };
          default_workspace = lib.mkDefault "notes";
          index = "index.norg";
        };
        # new notes get a @document.meta block (title, categories, ...)
        "core.esupports.metagen".config.type = "empty";
        # :Neorg generate-workspace-summary builds a tree of notes from their categories;
        # dotted categories (e.g. cs.compilers) nest
        "core.summary".__empty = null;
        "core.integrations.telescope".__empty = null;
        # lsp for link completion (via blink) and link-safe file/heading renames
        "external.interim-ls".__empty = null;
        "core.completion".config.engine.module_name = "external.lsp-completion";
        # :Neorg export to-file foo.md, :Neorg export directory <dir> markdown <out>
        "core.export".__empty = null;
        "core.export.markdown".config.extensions = "all"; # incl. metadata as yaml front matter
      };
      # dirman's file walk follows symlinks, e.g. into .direnv's store copies of nixpkgs, which
      # hangs pickers and pollutes summaries; walk without following symlinks or hidden dirs
      luaConfig.post = ''
        local dirman = require("neorg").modules.get_module("core.dirman")
        if dirman then
          local Path = require("pathlib")
          dirman.get_norg_files = function(workspace_name)
            local workspace = dirman.get_workspace(workspace_name)
            if not workspace then
              return
            end
            local files = {}
            local opts = {
              depth = 20,
              skip = function(dir)
                return not vim.fs.basename(dir):match("^%.")
              end,
            }
            for name, type in vim.fs.dir(tostring(workspace), opts) do
              if type == "file" and name:match("%.norg$") then
                table.insert(files, Path(tostring(workspace) .. "/" .. name))
              end
            end
            return files
          end
        end
      '';
    };

    extraPlugins = [ pkgs.vimPlugins.neorg-interim-ls ];
    dependencies.ripgrep.enable = true; # interim-ls references

    autoCmd = [
      {
        desc = "enables neorg concealer";
        event = "FileType";
        pattern = "norg";
        command = "setlocal conceallevel=2";
      }
      {
        # dirman doesn't do this itself; the deepest workspace containing the file wins
        desc = "switches neorg workspace to the one containing the file";
        event = "BufEnter";
        pattern = "*.norg";
        callback.__raw = ''
          function()
            local dirman = require("neorg").modules.get_module("core.dirman")
            if dirman then
              dirman.set_closest_workspace_match()
            end
          end
        '';
      }
    ];

    keymaps = [
      {
        action.__raw = ''
          function()
            -- re-editing the current index fails (E37) once it has unsaved changes
            local dirman = require("neorg").modules.get_module("core.dirman")
            local index = tostring(dirman.get_current_workspace()[2] / dirman.get_index())
            if vim.api.nvim_buf_get_name(0) ~= index then
              vim.cmd("Neorg index")
            end
          end
        '';
        key = "<leader>ni";
        options.desc = "Neorg: Open workspace index";
      }
      {
        action = "<Plug>(neorg.dirman.new-note)";
        key = "<leader>nn";
        options.desc = "Neorg: New note";
      }
      {
        action.__raw = ''
          function()
            -- the summary lives under the top-level heading containing the cursor; generate-workspace-summary
            -- only inserts, so clear that heading's old summary first
            if vim.bo.filetype ~= "norg" then
              return
            end
            local node
            local cur = vim.treesitter.get_node({ pos = { vim.api.nvim_win_get_cursor(0)[1] - 1, 0 } })
            while cur do
              if cur:type():match("^heading%d$") then
                node = cur
              end
              cur = cur:parent()
            end
            if not node then
              vim.notify("Neorg: cursor is not in a heading", vim.log.levels.WARN)
              return
            end
            local start_row, _, end_row, end_col = node:range()
            if end_col > 0 then
              end_row = end_row + 1
            end
            vim.api.nvim_buf_set_lines(0, start_row + 1, end_row, false, {})
            require("neorg").modules.get_module("core.summary").generate_workspace_summary(0, { start_row + 1, 0 })
          end
        '';
        key = "<leader>ns";
        options.desc = "Neorg: Regenerate summary by category under top-level heading";
      }
      {
        action.__raw = ''
          function()
            if vim.bo.filetype == "norg" then
              vim.cmd("Neorg export to-file " .. vim.fn.fnameescape(vim.fn.expand("%:p:r") .. ".md"))
            end
          end
        '';
        key = "<leader>ne";
        options.desc = "Neorg: Export note to markdown";
      }
      {
        action = "<cmd>Telescope neorg switch_workspace<CR>";
        key = "<leader>nw";
        options.desc = "Neorg: Switch workspace";
      }
      {
        action = "<cmd>Telescope neorg find_norg_files<CR>";
        key = "<leader>nf";
        options.desc = "Neorg: Find notes";
      }
      {
        action = "<cmd>Telescope neorg search_headings<CR>";
        key = "<leader>nh";
        options.desc = "Neorg: Find headings";
      }
      {
        action = "<cmd>Telescope neorg find_backlinks<CR>";
        key = "<leader>nb";
        options.desc = "Neorg: Find backlinks";
      }
      {
        action = "<cmd>Telescope neorg insert_link<CR>";
        key = "<leader>nl";
        options.desc = "Neorg: Insert link";
      }
      {
        action = "<cmd>Telescope neorg insert_file_link<CR>";
        key = "<leader>nL";
        options.desc = "Neorg: Insert file link";
      }
    ];
  };
}
