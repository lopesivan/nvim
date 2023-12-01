return {
  { "nvim-lua/plenary.nvim" },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help" } },
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },
  {
    "luukvbaal/statuscol.nvim",
    config = function()
      require("statuscol").setup {
        setopt = true,
      }
    end,
  },

  -- ╭──────────────────────╮
  -- │ FOld Ui modificatoin │
  -- ╰──────────────────────╯
  {
    "anuvyklack/pretty-fold.nvim",
    event = "BufReadPost",
    config = function()
      require("pretty-fold").setup {
        keep_indentation = false,
        -- fill_char = '━',
        fill_char = "⋅",
        sections = {
          left = {
            "━ ",
            function()
              return string.rep("*", vim.v.foldlevel)
            end,
            " ━┫",
            "content",
            "┣",
          },
          right = {
            "┫ ",
            "number_of_folded_lines",
            ": ",
            "percentage",
            " ┣━━",
          },
        },
      }
      -- for C++ only
      require("pretty-fold").ft_setup("cpp", {
        process_comment_signs = false,
        comment_signs = {
          "/**", -- C++ Doxygen comments
        },
        stop_words = {
          -- ╟─ "*" ──╭───────╮── "@brief" ──╭───────╮──╢
          --          ╰─ WSP ─╯              ╰─ WSP ─╯
          "%*%s*@brief%s*",
        },
      })
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      defaults = {
        ["<leader>g"] = { name = "+Git" },
        ["<leader>b"] = { name = "+Buffer" },
        ["<leader>h"] = { name = "+Harpoon" },
        ["<leader>hf"] = { name = "+Nav File" },
        ["<leader>hs"] = { name = "+Send Command" },
        ["<leader>t"] = { name = "+Terminal" },
        ["<leader>r"] = { name = "+Refactor" },
        ["<leader>fs"] = { name = "+Search" },
        ["<leader>fp"] = { name = "+Project" },
        ["<leader>fn"] = { name = "+Neovim" },
        ["<leader>nn"] = { name = "+Noice" },
      },
    },
  },
}
