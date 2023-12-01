return {

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      setup = {
        show_help = true,
        plugins = { spelling = true },
        key_labels = { ["<leader>"] = "SPC" },
        triggers = "auto",
        window = {
          border = "single", -- none, single, double, shadow
          position = "bottom", -- bottom, top
          margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
          padding = { 1, 1, 1, 1 }, -- extra window padding [top, right, bottom, left]
          winblend = 0,
        },
        layout = {
          height = { min = 4, max = 25 }, -- min and max height of the columns
          width = { min = 20, max = 50 }, -- min and max width of the columns
          spacing = 3, -- spacing between columns
          align = "left", -- align columns left, center or right
        },
      },
      defaults = {
        mode = { "n" },
        ["<leader>f"] = { name = "+File" },
        ["<leader>?"] = { cmd = "<cmd>q!<cr>", desc = "Quit" },
        ["<leader>\\"] = { cmd = '<cmd>set buftype=""|w!<CR>', desc = "Save" },
        ["ç"] = { cmd = '<cmd>exe "normal cxiw"<CR>', desc = "Swap" },
      },
    },
    config = function(_, opts)
      local wk = require "which-key"
      wk.setup(opts.setup)
      wk.register(opts.defaults)
    end,
  },

  {
    "neoclide/redismru.vim",
    event = "VeryLazy",
    build = "npm install",
    config = function()
      vim.g.redismru_limit = 100
    end,
  },
  -- "monaqa/dial.nvim", -- Better increment/decrement
  {
    "monaqa/dial.nvim",
    -- lazy-load on keys
    -- mode is `n` by default. For more advanced options, check the section on key mappings
    keys = { "<C-a>", { "<C-x>", mode = "n" } },
  },
  {
    "ellisonleao/dotenv.nvim",
    event = "VeryLazy",
    config = function()
      require("dotenv").setup()
    end,
  },

  {
    "ThePrimeagen/harpoon",
    config = function()
      require("config.harpoon").setup()
    end,
  },

  -- Git worktree utility6
  {
    "ThePrimeagen/git-worktree.nvim",
    config = function()
      require("git-worktree").setup {}
    end,
  },

  -- Refactoring
  {
    "ThePrimeagen/refactoring.nvim",
    keys = { [[<leader>r]] },
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("config.refactoring").setup()
    end,
  },

  -- terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup {
        open_mapping = [[<c-\>]],
        direction = "float",
      }
    end,
    event = "BufEnter",
  },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("config.project").setup()
    end,
  },
  "tamago324/lir.nvim",
  "tamago324/lir-git-status.nvim",

  {
    "tamago324/lir-mmv.nvim",
    cond = function()
      return vim.fn.executable "mmv" == 1
    end,
  },

  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPre",
    opts = {},
  },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    opts = function()
      local ai = require "mini.ai"
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      if require("utils").has "which-key.nvim" then
        ---@type table<string, string|table>
        local i = {
          [" "] = "Whitespace",
          ['"'] = 'Balanced "',
          ["'"] = "Balanced '",
          ["`"] = "Balanced `",
          ["("] = "Balanced (",
          [")"] = "Balanced ) including white-space",
          [">"] = "Balanced > including white-space",
          ["<lt>"] = "Balanced <",
          ["]"] = "Balanced ] including white-space",
          ["["] = "Balanced [",
          ["}"] = "Balanced } including white-space",
          ["{"] = "Balanced {",
          ["?"] = "User Prompt",
          _ = "Underscore",
          a = "Argument",
          b = "Balanced ), ], }",
          c = "Class",
          f = "Function",
          o = "Block, conditional, loop",
          q = "Quote `, \", '",
          t = "Tag",
        }
        local a = vim.deepcopy(i)
        for k, v in pairs(a) do
          a[k] = v:gsub(" including.*", "")
        end

        local ic = vim.deepcopy(i)
        local ac = vim.deepcopy(a)
        for key, name in pairs { n = "Next", l = "Last" } do
          i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
          a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
        end
        require("which-key").register {
          mode = { "o", "x" },
          i = i,
          a = a,
        }
      end
    end,
  },
}
