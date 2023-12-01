-- programa em lua
return {
  {
    "jedrzejboczar/possession.nvim",
    config = function()
      require("config.possession").setup()
    end,
    cmd = {
      "PossessionSave",
      "PosessionLoad",
      "PosessionShow",
      "PossessionList",
    },
  },

  {
    "antoinemadec/FixCursorHold.nvim",
    event = "BufReadPre",
    config = function()
      vim.g.cursorhold_updatetime = 100
    end,
  },
  -- Git Integration
  -- Added this plugin
  {
    "lewis6991/gitsigns.nvim",
    keys = {
      { "<leader>gg", "<cmd>lua require('config.telescope').buffer_git_files()<cr>", desc = "git files" },
      { "<leader>gtg", "<cmd>lua require('config.telescope').buffer_git_files()<cr>", desc = "git files" },

      {
        "<leader>gm",
        function()
          local message = vim.fn.input "[branch[s]] > "
          if message == "" then
            print "Mensagem de stash está vazia. Nenhuma ação foi executada."
            return
          end
          local cmd = string.format("git merge --no-ff %s --no-commit", message)
          vim.fn.system(cmd)
          message = vim.fn.input "[message] > "
          if message == "" then
            message = "join ..."
          end
          cmd = string.format("git commit -m '%s'", message)
          vim.fn.system(cmd)
        end,
        desc = "Merge",
      },
      {
        "<leader>gSc",
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
      {
        "<leader>gSs",
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
      { "<leader>gS0", "<CMD>Git stash<CR>", desc = "stash" },
      { "<leader>gSp", "<CMD>Git stash pop<CR>", desc = "stash pop" },
      { "<leader>gSl", "<CMD>Git stash list<CR>", desc = "stash list" },

      { "<leader>ga", "<CMD>Git add %:p<CR>", desc = "git add" },
      { "<leader>gu", "<CMD>Git rm --cached %:p<CR>", desc = "git uadd" },
      { "<leader>gtb", "<cmd>lua require('config.telescope').git_branches()<cr>", desc = "git branches" },
      { "<leader>gtc", "<cmd>lua require('config.telescope').git_commits()<cr>", desc = "git commit" },
      -- { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Diff" },
      { "<leader>gds", "<cmd>Gitsigns diffthis<cr>", desc = "w - stage" },
      { "<leader>gdh", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "w - repo" },
      { "<leader>gdc", "<cmd>Gitsigns diffthis --cached<cr>", desc = "stage - repo" },

      { "<leader>ghj", "<cmd>lua require 'gitsigns'.next_hunk()<cr>", desc = "Next Hunk" },
      { "<leader>ghk", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", desc = "Prev Hunk" },
      { "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>", desc = "Blame" },
      { "<leader>gcu", "<CMD>Git checkout -- %:p<CR>", desc = "checkout --" },
      { "<leader>gcU", "<CMD>Git checkout HEAD %:p<CR>", desc = "checkout HEAD" },
      { "<leader>grh", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", desc = "Reset Hunk" },
      { "<leader>grb", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", desc = "Reset Buffer" },
      {
        "<leader>gC",
        function()
          local message = vim.fn.input "[message] > "
          if message == "" then
            print "Mensagem de commit está vazia. Nenhuma ação foi executada."
            return
          end
          local cmd = string.format("git commit -m '%s'", message)
          vim.fn.system(cmd)
        end,
        desc = "Git Commit file",
      },
      { "<leader>go", "<cmd>Telescope git_status<cr>", desc = "Open changed file" },
      {
        "<leader>gtr",
        function()
          local reflog = { "git", "reflog", "--pretty=%h %gs" }
          require("telescope").extensions.advanced_git_search.checkout_reflog(reflog)
        end,
        desc = "Git Search: Checkout Reflog",
      },
    },
  },
  -- Jumps
  {
    "phaazon/hop.nvim",
    cmd = { "HopWord", "HopChar1" },
    config = function()
      require("hop").setup {}
    end,
    keys = {
      {
        "<space>/",
        "<CMD>HopWord<CR>",
        desc = "HopWord",
      },
    },
  },

  {
    "chentoast/marks.nvim",
    event = "BufReadPre",
    config = function()
      require("marks").setup {}
    end,
  },
  --  Plugins:  Navegando usando `marks'
  --[[
        use "kshenoy/vim-signature"
mx         Toggle mark 'x' and display it in the leftmost column
dmx        Remove mark 'x' where x is a-zA-Z

m,         Place the next available mark
m.         If no mark on line, place the next available mark. Otherwise, remove (first) existing mark.
m-         Delete all marks from the current line
m<Space>   Delete all marks from the current buffer
]`         Jump to next mark
[`         Jump to prev mark
]'         Jump to start of next line containing a mark
['         Jump to start of prev line containing a mark
`]         Jump by alphabetical order to next mark
`[         Jump by alphabetical order to prev mark
']         Jump by alphabetical order to start of next line having a mark
'[         Jump by alphabetical order to start of prev line having a mark
m/         Open location list and display marks from current buffer

m[0-9]     Toggle the corresponding marker !@#$%^&*()
m<S-[0-9]> Remove all markers of the same type
]-         Jump to next line having a marker of the same type
[-         Jump to prev line having a marker of the same type
]=         Jump to next line having a marker of any type
[=         Jump to prev line having a marker of any type
m?         Open location list and display markers from current buffer
m<BS>      Remove all markers
--]]

  -- Lua
  {
    "abecodes/tabout.nvim",
    event = "BufReadPre",
    config = function()
      require("tabout").setup {
        tabkey = "<Tab>", -- key to trigger tabout, set to an empty string to disable
        backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
        act_as_tab = true, -- shift content if tab out is not possible
        act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
        default_tab = "<C-t>", -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
        default_shift_tab = "<C-d>", -- reverse shift default action,
        enable_backwards = true, -- well ...
        completion = true, -- if the tabkey is used in a completion pum
        tabouts = {
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = "`", close = "`" },
          { open = "(", close = ")" },
          { open = "[", close = "]" },
          { open = "{", close = "}" },
        },
        ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
        exclude = {}, -- tabout will ignore these filetypes
      }
    end,
  },

  { "Junegunn/vim-easy-align", event = "BufReadPre" },

  -- compila
  "lopesivan/yabs.nvim",

  "RishabhRD/nvim-cheat.sh",
  "RishabhRD/popfix",

  -- Debugging
  -- Debug adapter protocol
  -- use "mfussenegger/nvim-dap"
  -- use "rcarriga/nvim-dap-ui"
  -- use "theHamsta/nvim-dap-virtual-text"
  -- use "mfussenegger/nvim-dap-python"

  --
  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("config.autopairs").setup()
    end,
  },

  -- Optional: Used to make nice menus
  { "skywind3000/quickmenu.vim", event = "BufEnter" },
  -- For narrowing regions of text to look at them alone

  { "chrisbra/NrrwRgn", event = "VeryLazy" },

  {
    "godlygeek/tabular",
    event = "BufEnter",
    -- event = "VeryLazy",
  }, -- Quickly align text by pattern

  -- nvim-tree
  --[[
  {
    "kyazdani42/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeClose" },
    -- module = "nvim-tree",
    config = function()
      require("config.nvimtree").setup()
    end,
    keys = {
      {
        "<leader>ee",
        "<Cmd>NvimTreeToggle<CR>",
        desc = "NvimTree Toggle",
      },
    },
  },
  ]]

  -- Buffer
  {
    "kazhala/close-buffers.nvim",
    cmd = { "BDelete", "BWipeout" },

    -- name = "Buffer",
    -- b = { c("BufferLinePick"), "Pick a Buffer" },
    -- d = { c("BDelete this"), "Close Buffer" },
    -- D = { c("BWipeout other"), "Delete All Buffers" },
    -- f = { c("BDelete! this"), "Force Close Buffer" },
    -- p = { c("BufferLinePickClose"), "Pick & Close a Buffer" },
    -- q = {
    -- 	c("call setqflist(map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), '{\"bufnr\": v:val}'))<BAR>copen"),
    -- 	"Buffer to quickfix",
    -- },
    keys = {
      {
        "<leader>bb",
        "<cmd>BufferLinePick<cr>",
        desc = "Pick a Buffer",
      },
      { "<leader>bd", "<cmd>BDelete this<cr>", desc = "Close Buffer" },
      {
        "<leader>bD",
        "<cmd>BWipeout other<cr>",
        desc = "Delete All Buffers",
      },
      {
        "<leader>bf",
        "<cmd>BDelete! this<cr>",
        desc = "Force Close Buffer",
      },
      {
        "<leader>bp",
        "<cmd>BufferLinePickClose<cr>",
        desc = "Pick & Close a Buffer",
      },
      {
        "<leader>bq",
        "<cmd>call setqflist(map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), '{\"bufnr\": v:val}'))<BAR>copen<cr>",
        desc = "Buffer to quickfix",
      },
    },
  },
  {
    "tommcdo/vim-exchange",
    event = "BufEnter",
    -- event = "VeryLazy",
  },
  {
    "andrewradev/switch.vim",
    event = "BufEnter",
    -- event = "VeryLazy",
    keys = {
      { "-", "<Cmd>Switch<CR>", desc = "Switch word under cursor" },
    },
    init = function()
      -- Disable default mapping.
      vim.g.switch_mapping = ""
    end,
  },

  -- Auto tag
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup { enable = true }
    end,
  },

  -- End wise
  {
    "RRethy/nvim-treesitter-endwise",
    event = "InsertEnter",
  },

  -- Buffer line
  {
    "akinsho/nvim-bufferline.lua",
    event = "BufReadPre",
    config = function()
      require("config.bufferline").setup()
    end,
  },
  {
    "m-demare/hlargs.nvim",
    config = function()
      require("config.ui.hlargs").setup()
    end,
  },

  {
    "mg979/vim-visual-multi",
    -- lazy = false,
    event = "VeryLazy",
    init = function()
      vim.cmd "let g:VM_quit_after_leaving_insert_mode = 1"
      vim.cmd "let g:VM_skip_empty_lines = 1"
      vim.cmd "let g:VM_default_mappings = 0"
      vim.cmd "let g:VM_mouse_mappings = 1"
      -- vim.cmd("let g:VM_theme = 'sand'")

      -- (More here: https://github.com/mg979/vim-visual-multi/wiki/Mappings)
      vim.cmd "let g:VM_maps = {}"
      vim.cmd "let g:VM_maps['Add Cursor Up'] = '¹'"
      vim.cmd "let g:VM_maps['Add Cursor Down'] = '²'"
      vim.cmd "let g:VM_maps['Visual Cursors'] = '³'"
      vim.cmd "let g:VM_maps['Add Cursor At Pos'] = '£'"
      vim.cmd "let g:VM_maps['Start Regex Search'] = '¢'"
    end,
  },

  {
    "ellisonleao/carbon-now.nvim",
    opts = {
      options = {
        theme = "nord",
        font_family = "JetBrains Mono",
        open_cmd = "chrome",
      },
    },
    keys = {
      { "<leader>cn", [[<Cmd>CarbonNow<CR>]], mode = "v" },
    },
    cmd = "CarbonNow",
  },

  {
    "anuvyklack/hydra.nvim",
    event = { "VeryLazy" },
    opts = {
      specs = {},
    },
    config = function(_, opts)
      local hydra = require "hydra"
      for s, _ in pairs(opts.specs) do
        hydra(opts.specs[s]())
      end
    end,
  },
}
