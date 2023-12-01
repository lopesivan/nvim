local function git_menu()
  local hint = [[
 _a_: Git add                _C_: Commit
 _b_: Checkout branch        _0_: cherry-pick
 _c_: Checkout commit        _1_: stash
 _d_: Diff                   _2_: stash save
 _j_: Next Hunk              _3_: stash list
 _k_: Prev Hunk              _4_: stash pop
 _l_: Blame                  _5_: init
 _o_: Status                 _6_: bare
 _S_: Stage Hunk
 _U_: Undo Hunk
 ^ ^               _q_: Quit
]]

  return {
    name = "Git",
    hint = hint,
    config = {
      color = "pink",
      invoke_on_body = true,
      hint = {
        border = "rounded",
        position = "middle-right",
      },
    },
    mode = "n",
    body = "<m-g>",
        -- stylua: ignore
    heads = {
        { "a", "<CMD>Git add %:p<CR>", desc = "git add" },
        { "b", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch" },
        { "q", nil, { exit = true, nowait = true, desc = "Exit" } },
        { "c", "<cmd>Telescope git_commits<cr>", desc = "Checkout commit", },
        { "d", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Diff", },
        { "j", "<cmd>lua require 'gitsigns'.next_hunk()<cr>", desc = "Next Hunk", },
        { "k", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", desc = "Prev Hunk", },
        { "l", "<cmd>lua require 'gitsigns'.blame_line()<cr>", desc = "Blame", },
        { "o", "<cmd>Telescope git_status<cr>", desc = "Open changed file", },
        { "S", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", desc = "Stage Hunk", },
        { "U", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", desc = "Undo Stage Hunk", },
        { "C", function()
                local message = vim.fn.input "[message] > "
                local cmd = string.format("git commit -m '%s'", message)
                vim.fn.system(cmd)
            end, desc = "Commit",
            },
      {
        "0",
        function()
          local message = vim.fn.input "[branch] > "
          if message == "" then
            print "Mensagem de stash está vazia. Nenhuma ação foi executada."
            return
          end
          local cmd = string.format("git cherry-pick %s", message)
          vim.fn.system(cmd)
        end,
        desc = "🌸",
      },
      { "1", "<CMD>Git stash<CR>", desc = "stash" },
      {
        "2",
        function()
          local message = vim.fn.input "[message] > "
          if message == "" then
            print "Mensagem de stash está vazia. Nenhuma ação foi executada."
            return
          end
          local cmd = string.format("git stash save %s", message)
          vim.fn.system(cmd)
        end,
        desc = "stash save",
      },
      { "3", "<CMD>Git stash list<CR>", desc = "stash list" },
      { "4", "<CMD>Git stash pop<CR>", desc = "stash pop" },
      {
        "5",
        function()
          local message = vim.fn.input "[dir name] > "
          if message == "" then
            print "Mensagem de stash está vazia. Nenhuma ação foi executada."
            return
          end
          local cmd = string.format("git init %s", message)
          vim.fn.system(cmd)
        end,
        desc = "git init",
      },
      {
        "6",
        function()
          local message = vim.fn.input "[dir name] > "
          if message == "" then
            print "Mensagem de stash está vazia. Nenhuma ação foi executada."
            return
          end
          local cmd = string.format("git init --bare %s", message)
          vim.fn.system(cmd)
        end,
        desc = "git init bare",
      },

    },
  }
end

local function dap_menu()
  local dap = require "dap"
  local dapui = require "dapui"
  local dap_widgets = require "dap.ui.widgets"

  local hint = [[
 _t_: Toggle Breakpoint             _R_: Run to Cursor
 _s_: Start                         _E_: Evaluate Input
 _c_: Continue                      _C_: Conditional Breakpoint
 _b_: Step Back                     _U_: Toggle UI
 _d_: Disconnect                    _S_: Scopes
 _e_: Evaluate                      _X_: Close
 _g_: Get Session                   _i_: Step Into
 _h_: Hover Variables               _o_: Step Over
 _r_: Toggle REPL                   _u_: Step Out
 _x_: Terminate                     _p_: Pause
 ^ ^               _q_: Quit
]]

  return {
    name = "Debug",
    hint = hint,
    config = {
      color = "pink",
      invoke_on_body = true,
      hint = {
        border = "rounded",
        position = "middle-right",
      },
    },
    mode = "n",
    body = "<m-d>",
        -- stylua: ignore
        heads = {
            { "C", function() dap.set_breakpoint(vim.fn.input "[Condition] > ") end, desc = "Conditional Breakpoint", },
            { "E", function() dapui.eval(vim.fn.input "[Expression] > ") end,        desc = "Evaluate Input", },
            { "R", function() dap.run_to_cursor() end,                               desc = "Run to Cursor", },
            { "S", function() dap_widgets.scopes() end,                              desc = "Scopes", },
            { "U", function() dapui.toggle() end,                                    desc = "Toggle UI", },
            { "X", function() dap.close() end,                                       desc = "Quit", },
            { "b", function() dap.step_back() end,                                   desc = "Step Back", },
            { "c", function() dap.continue() end,                                    desc = "Continue", },
            { "d", function() dap.disconnect() end,                                  desc = "Disconnect", },
            {
                "e",
                function() dapui.eval() end,
                mode = { "n", "v" },
                desc = "Evaluate",
            },
            { "g", function() dap.session() end,           desc = "Get Session", },
            { "h", function() dap_widgets.hover() end,     desc = "Hover Variables", },
            { "i", function() dap.step_into() end,         desc = "Step Into", },
            { "o", function() dap.step_over() end,         desc = "Step Over", },
            { "p", function() dap.pause.toggle() end,      desc = "Pause", },
            { "r", function() dap.repl.toggle() end,       desc = "Toggle REPL", },
            { "s", function() dap.continue() end,          desc = "Start", },
            { "t", function() dap.toggle_breakpoint() end, desc = "Toggle Breakpoint", },
            { "u", function() dap.step_out() end,          desc = "Step Out", },
            { "x", function() dap.terminate() end,         desc = "Terminate", },
            { "q", nil, {
                exit = true,
                nowait = true,
                desc = "Exit"
            } },
        },
  }
end

local function repl_menu()
  local cmd = require("hydra.keymap-util").cmd

  local hint = [[
 ^
 _s_: Send Motion
 _l_: Send Line
 _t_: Send Until Cursor
 _f_: Send File

 _R_: Show REPL          _c_: Clear
 _C_: Close REPL         _L_: Clear Highlight
 _S_: Restart REPL       _<CR>_: ENTER
 _F_: Focus              _I_: Interrupt
 _H_: Hide
                  ^ ^  _q_: Quit
]]

  return {
    name = "REPL",
    hint = hint,
    config = {
      color = "pink",
      invoke_on_body = true,
      hint = {
        border = "rounded",
        position = "top-left",
      },
    },
    mode = "n",
    body = "<m-x>",
    -- stylua: ignore
    heads = {
      { "s", function() require("iron.core").run_motion("send_motion") end, desc = "Send Motion" },
      { "l", function() require("iron.core").send_line() end, desc = "Send Line" },
      { "t", function() require("iron.core").send_until_cursor() end, desc = "Send Until Cursor" },
      { "f", function() require("iron.core").send_file() end, desc = "Send File" },
      { "L", function() require("iron.marks").clear_hl() end, mode = {"v"}, desc = "Clear Highlight" },
      { "<CR>", function() require("iron.core").send(nil, string.char(13)) end, desc = "ENTER" },
      { "I", function() require("iron.core").send(nil, string.char(03)) end, desc = "Interrupt" },
      { "C", function() require("iron.core").close_repl() end, desc = "Close REPL" },
      { "c", function() require("iron.core").send(nil, string.char(12)) end, desc = "Clear" },
      { "R", cmd("IronRepl"),    desc  = "REPL" },
      { "S", cmd("IronRestart"), desc  = "Restart" },
      { "F", cmd("IronFocus"),   desc  = "Focus" },
      { "H", cmd("IronHide"),    desc  = "Hide" },
      { "q", nil, { exit = true, nowait = true, desc = "Exit" } },
    },
  }
end

return {
  {
    "Vigemus/iron.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        config = {
          -- Whether a repl should be discarded or not
          scratch_repl = true,
          -- Your repl definitions come here

          repl_definition = {
            python = require("iron.fts.python").ipython,
            scala = require("iron.fts.scala").scala,
            cpp = require("iron.fts.cpp").cpp,
            julia = require("iron.fts.julia").julia,
            javascript = require("iron.fts.javascript").javascript,
            maple = require("iron.fts.maple").maple,
            spice = require("iron.fts.spice").ngspice,
          },
          -- How the repl window will be displayed
          -- See below for more information
          repl_open_cmd = require("iron.view").right "50%",
        },
        -- If the highliht is on, you can change how it looks
        -- For the available options, check nvim_set_hl
        highlight = {
          italic = true,
        },
        ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
      }
    end,
    -- stylua: ignore
    keys = {
      { "<leader>xs", function() require("iron.core").run_motion("send_motion") end, desc = "Send Motion" },
      { "<leader>xs", function() require("iron.core").visual_send() end, mode = {"v"}, desc = "Send" },
      { "<leader>xl", function() require("iron.core").send_line() end, desc = "Send Line" },
      { "<leader>xt", function() require("iron.core").send_until_cursor() end, desc = "Send Until Cursor" },
      { "<leader>xf", function() require("iron.core").send_file() end, desc = "Send File" },
      { "<leader>xL", function() require("iron.marks").clear_hl() end, mode = {"v"}, desc = "Clear Highlight" },
      { "<leader>x<cr>", function() require("iron.core").send(nil, string.char(13)) end, desc = "ENTER" },
      { "<leader>xI", function() require("iron.core").send(nil, string.char(03)) end, desc = "Interrupt" },
      { "<leader>xC", function() require("iron.core").close_repl() end, desc = "Close REPL" },
      { "<leader>xc", function() require("iron.core").send(nil, string.char(12)) end, desc = "Clear" },
      { "<leader>xms", function() require("iron.core").send_mark() end, desc = "Send Mark" },
      { "<leader>xmm", function() require("iron.core").run_motion("mark_motion") end, desc = "Mark Motion" },
      { "<leader>xmv", function() require("iron.core").mark_visual() end, mode = {"v"}, desc = "Mark Visual" },
      { "<leader>xmr", function() require("iron.marks").drop_last() end, desc = "Remove Mark" },
      { "<leader>xR", "<cmd>IronRepl<cr>", desc = "REPL" },
      { "<leader>xS", "<cmd>IronRestart<cr>", desc = "Restart" },
      { "<leader>xF", "<cmd>IronFocus<cr>", desc = "Focus" },
      { "<leader>xH", "<cmd>IronHide<cr>", desc = "Hide" },
    },
    config = function(_, opts)
      local iron = require "iron.core"
      iron.setup(opts)
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      defaults = {
        ["<leader>x"] = { name = "+REPL" },
        ["<leader>xm"] = { name = "+Mark" },
      },
    },
  },
  {
    "anuvyklack/hydra.nvim",
    opts = {
      specs = {
        repl = repl_menu,
        dap = dap_menu,
        git = git_menu,
      },
    },
  },
  {
    "echasnovski/mini.ai",
    opts = function(_, opts)
      opts.custom_textobjects = vim.tbl_extend("force", opts.custom_textobjects, { h = miniai_spec })
    end,
  },
}
