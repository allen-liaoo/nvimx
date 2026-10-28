# Scrollbar
# https://github.com/dstein64/nvim-scrollview/
{
  config,
  lib,
  ...
}:

let
  gitsignsPriority = 20;
  gitsignsAddSymbol = "▕"; # "▏"
  gitsignsChangeSymbol = "▕"; # "▏"
  gitsignsDeleteSymbol = "-";
in
{
  plugins.scrollview = {
    enable = true;
    settings = {
      signs_on_startup = [
        "conflicts"
        "cursor"
        "diagnostics"
        "folds"
        "marks"
        "search"
      ];
      # draw signs on top of the scrollbar instead of beside it
      signs_scrollbar_overlap = "over";
      signs_max_per_row = 2;
      diagnostics_severities = [ (lib.nixvim.mkRaw "vim.diagnostic.severity.ERROR") ];
    };
  };

  # after gitsigns.setup(), which runs before extraConfigLua
  extraConfigLua = lib.mkIf config.plugins.gitsigns.enable ''
    require('scrollview.contrib.gitsigns').setup({
      add_symbol = '${gitsignsAddSymbol}',
      change_symbol = '${gitsignsChangeSymbol}',
      delete_symbol = '${gitsignsDeleteSymbol}',
      
      add_priority = ${toString gitsignsPriority},
      change_priority = ${toString gitsignsPriority},
      delete_priority = ${toString gitsignsPriority},
    })

    -- staged hunks, mirroring the contrib above. gitsigns.get_hunks() only
    -- returns unstaged hunks, so read hunks_staged from gitsigns' internal cache
    do
      local api = vim.api
      local scrollview = require('scrollview')
      local group = 'gitsigns_staged'
      scrollview.register_sign_group(group)

      local function spec(variant, highlight, symbol)
        return scrollview.register_sign_spec({
          extend = true,
          group = group,
          highlight = highlight,
          -- higher priority is placed closer to the scrollbar (rightmost, with
          -- the default signs_overflow = 'left'), so staged sits right of unstaged
          priority = ${toString (gitsignsPriority + 1)},
          symbol = symbol,
          variant = variant,
        }).name
      end
      local add = spec('add', 'GitSignsStagedAdd', '${gitsignsAddSymbol}')
      local change = spec('change', 'GitSignsStagedChange', '${gitsignsChangeSymbol}')
      local delete = spec('delete', 'GitSignsStagedDelete', '${gitsignsDeleteSymbol}')

      scrollview.set_sign_group_state(group, true)

      -- buffers given signs on the last update, cleared on the next one
      local active_bufnrs = {}

      api.nvim_create_autocmd('User', {
        pattern = 'GitSignsUpdate',
        callback = function()
          local cache = require('gitsigns.cache').cache
          for bufnr, _ in pairs(active_bufnrs) do
            if api.nvim_buf_is_valid(bufnr) then
              vim.b[bufnr][add] = {}
              vim.b[bufnr][change] = {}
              vim.b[bufnr][delete] = {}
            end
          end
          active_bufnrs = {}
          for _, winid in ipairs(api.nvim_list_wins()) do
            local bufnr = api.nvim_win_get_buf(winid)
            local hunks = cache[bufnr] and cache[bufnr].hunks_staged or {}
            if not vim.tbl_isempty(hunks) then
              active_bufnrs[bufnr] = true
            end
            local lines_add, lines_change, lines_delete = {}, {}, {}
            local function insert_range(lines, first, count)
              for line = first, first + count - 1 do
                table.insert(lines, line)
              end
            end
            for _, hunk in ipairs(hunks) do
              if hunk.type == 'add' then
                -- hide a fully staged new file rather than fill the column
                if hunk.added.count < api.nvim_buf_line_count(bufnr) then
                  insert_range(lines_add, hunk.added.start, hunk.added.count)
                end
              elseif hunk.type == 'change' then
                -- a change hunk may also add lines after the changed ones
                local changed = math.min(hunk.added.count, hunk.removed.count)
                insert_range(lines_change, hunk.added.start, changed)
                insert_range(lines_add, hunk.added.start + changed, hunk.added.count - changed)
              elseif hunk.type == 'delete' then
                table.insert(lines_delete, hunk.added.start)
              end
            end
            vim.b[bufnr][add] = lines_add
            vim.b[bufnr][change] = lines_change
            vim.b[bufnr][delete] = lines_delete
          end
          if scrollview.is_sign_group_active(group) then
            vim.cmd('silent! ScrollViewRefresh')
          end
        end,
      })
    end
  '';
}
