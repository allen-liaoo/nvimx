{
  config,
  lib,
  ...
}:

let
  prefix = "<Space>";
in
{
  config = lib.mkIf (config.nvimx.dap.enable) {
    keymaps = [
      {
        key = "${prefix}b";
        action.__raw = "function() require('dap').toggle_breakpoint() end";
        options.desc = "DAP: Toggle breakpoint";
      }
      {
        key = "${prefix}B";
        action.__raw = "function() require('dap').set_breakpoint(vim.fn.input('Condition: ')) end";
        options.desc = "DAP: Conditional breakpoint";
      }
      {
        key = "${prefix}s";
        action.__raw = "function() dap_step_mode(true) end";
        options.desc = "DAP: Step mode (starts a session if none)";
      }
      {
        key = "${prefix}r";
        action.__raw = "function() require('dap').continue() end";
        options.desc = "DAP: Run/continue";
      }
      {
        key = "${prefix}R";
        action.__raw = "function() require('dap').run_last() end";
        options.desc = "DAP: Run last";
      }
      {
        key = "${prefix}c";
        action.__raw = "function() require('dap').run_to_cursor() end";
        options.desc = "DAP: Run to cursor";
      }
      {
        key = "${prefix}t";
        action.__raw = "function() require('dap').terminate() end";
        options.desc = "DAP: Terminate";
      }
      {
        key = "${prefix}p";
        action.__raw = "function() require('dap').repl.toggle() end";
        options.desc = "DAP: Toggle REPL";
      }
      {
        key = "${prefix}u";
        action.__raw = "function() require('dapui').toggle() end";
        options.desc = "DAP: Toggle UI";
      }
      {
        key = "${prefix}e";
        action.__raw = "function() require('dapui').eval() end";
        mode = [ "n" "v" ];
        options.desc = "DAP: Eval expression";
      }
    ];

    extraConfigLua = ''
      -- open/close dap-ui automatically with debug sessions
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- step mode: hjkl/arrows drive the debugger until <Esc>/q or the session ends
      local step_keys = {
        { { "j", "<Down>" },  dap.step_over, "Step over" },
        { { "l", "<Right>" }, dap.step_into, "Step into" },
        { { "h", "<Left>" },  dap.step_out,  "Step out" },
        { { "k", "<Up>" },    dap.continue,  "Continue" },
        { { "<Esc>", "q" },   function() dap_step_mode(false) end, "Exit step mode" },
      }
      local saved_maps = nil

      function dap_step_mode(enable)
        if enable then
          if not dap.session() then dap.continue() end
          if saved_maps then return end
          saved_maps = {}
          for _, spec in ipairs(step_keys) do
            for _, key in ipairs(spec[1]) do
              -- remember any existing global mapping so it can be restored
              local prev = vim.fn.maparg(key, "n", false, true)
              if not vim.tbl_isempty(prev) and prev.buffer == 0 then
                table.insert(saved_maps, prev)
              end
              vim.keymap.set("n", key, spec[2], { desc = "DAP step: " .. spec[3] })
            end
          end
          vim.notify("DAP step mode: j/↓ over, l/→ into, h/← out, k/↑ continue, Esc/q exit")
        elseif saved_maps then
          for _, spec in ipairs(step_keys) do
            for _, key in ipairs(spec[1]) do
              pcall(vim.keymap.del, "n", key)
            end
          end
          for _, prev in ipairs(saved_maps) do
            vim.fn.mapset("n", false, prev)
          end
          saved_maps = nil
          vim.notify("DAP step mode: off")
        end
      end

      dap.listeners.before.event_terminated["step_mode"] = function() dap_step_mode(false) end
      dap.listeners.before.event_exited["step_mode"] = function() dap_step_mode(false) end
    '';
  };
}
