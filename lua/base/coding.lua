return {

  {
    "hinell/duplicate.nvim",
    keys = {
      { "<F13>", "<CMD>LineDuplicate -1<CR>", desc = "Line Duplicate -1" },
      { "<F14>", "<CMD>LineDuplicate +1<CR>", desc = "Line Duplicate +1" },
      { "<F13>", "<CMD>VisualDuplicate -1<CR>", mode = "v", desc = "Line Duplicate -1" },
      { "<F14>", "<CMD>VisualDuplicate +1<CR>", mode = "v", desc = "Line Duplicate +1" },
    },
  },

  {
    "hinell/lsp-timeout.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
  },

  {
    "lervag/vimtex",
    ft = "tex",
    config = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.tex_flavor = "latex"
      vim.opt.conceallevel = 2
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
    ft = { "markdown" },
  },

  {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = "markdown",
    event = "VeryLazy",
    config = function()
      require("headlines").setup {
        markdown = {
          query = vim.treesitter.query.parse(
            "markdown",
            [[
                            (atx_heading [
                                (atx_h1_marker)
                                (atx_h2_marker)
                                (atx_h3_marker)
                                (atx_h4_marker)
                                (atx_h5_marker)
                                (atx_h6_marker)
                            ] @headline)

                            (thematic_break) @dash

                            (fenced_code_block) @codeblock

                            (block_quote_marker) @quote
                            (block_quote (paragraph (inline (block_continuation) @quote)))
                        ]]
          ),
          headline_highlights = { "Headline" },
          codeblock_highlight = "CodeBlock",
          dash_highlight = "Dash",
          dash_string = "-",
          quote_highlight = "Quote",
          quote_string = "┃",
          fat_headlines = true,
          fat_headline_upper_string = "▃",
          fat_headline_lower_string = "🬂",
        },
      }
    end,
  },

  -- {
  --   "kylechui/nvim-surround",
  --   event = "VeryLazy",
  --   opts = {},
  -- },

  {
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    keys = { { "gc", mode = { "n", "v" } }, { "gcc", mode = { "n", "v" } }, { "gbc", mode = { "n", "v" } } },
    config = function(_, _)
      local opts = {
        ignore = "^$",
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
      require("Comment").setup(opts)
    end,
  },
  {
    "andymass/vim-matchup",
    event = { "BufReadPost" },
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      defaults = {
        ["<leader>t"] = { name = "+Test" },
        ["<leader>tt"] = { name = "+Task" },
      },
    },
  },
  {
    "vim-test/vim-test",
    opts = {
      setup = {},
    },
    config = function(plugin, opts)
      vim.g["test#strategy"] = "neovim"
      vim.g["test#neovim#term_position"] = "belowright"
      vim.g["test#neovim#preserve_screen"] = 1

      -- Set up vim-test
      for k, _ in pairs(opts.setup) do
        opts.setup[k](plugin, opts)
      end
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-vim-test",
      "vim-test/vim-test",
      "stevearc/overseer.nvim",
    },
    keys = {
      { "<leader>td", "<cmd>w|lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", desc = "Debug File" },
      { "<leader>tL", "<cmd>w|lua require('neotest').run.run_last({strategy = 'dap'})<cr>", desc = "Debug Last" },
      { "<leader>ta", "<cmd>w|lua require('neotest').run.attach()<cr>", desc = "Attach" },
      { "<leader>tf", "<cmd>w|lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "File" },
      { "<leader>tF", "<cmd>w|lua require('neotest').run.run(vim.loop.cwd())<cr>", desc = "All Files" },
      { "<leader>tl", "<cmd>w|lua require('neotest').run.run_last()<cr>", desc = "Last" },
      { "<leader>tn", "<cmd>w|lua require('neotest').run.run()<cr>", desc = "Nearest" },
      { "<leader>tN", "<cmd>w|lua require('neotest').run.run({strategy = 'dap'})<cr>", desc = "Debug Nearest" },
      { "<leader>to", "<cmd>w|lua require('neotest').output.open({ enter = true })<cr>", desc = "Output" },
      { "<leader>ts", "<cmd>w|lua require('neotest').run.stop()<cr>", desc = "Stop" },
      { "<leader>tg", "<cmd>w|lua require('neotest').summary.toggle()<cr>", desc = "Summary" },
    },
    opts = function()
      return {
        adapters = {
          require "neotest-vim-test" {
            ignore_file_types = { "python", "vim", "lua" },
          },
        },
        status = { virtual_text = true },
        output = { open_on_run = true },
        -- overseer.nvim
        consumers = {
          overseer = require "neotest.consumers.overseer",
        },
        overseer = {
          enabled = true,
          force_default = true,
        },
      }
    end,
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace "neotest"
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup(opts)
    end,
  },
}
