return {
  {
    "nvim-telescope/telescope.nvim",
    event = "BufEnter",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-hop.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      {
        "AckslD/nvim-neoclip.lua",
        config = function()
          require("neoclip").setup()
        end,
      },
      "nvim-telescope/telescope.nvim",
      "nvim-telescope/telescope-rs.nvim",
      "nvim-telescope/telescope-fzf-writer.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },

      "nvim-telescope/telescope-packer.nvim",
      "nvim-telescope/telescope-hop.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-smart-history.nvim",
      "nvim-telescope/telescope-dap.nvim",
      "nvim-telescope/telescope-github.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      "nvim-telescope/telescope-cheat.nvim",
      "nvim-telescope/telescope-project.nvim",
      "cljoly/telescope-repo.nvim",
      "aaronhallaert/advanced-git-search.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      --      {
      --        "nvim-telescope/telescope-frecency.nvim",
      --        dependencies = { "tami5/sqlite.lua" },
      --      },
      {
        "nvim-telescope/telescope-frecency.nvim",
        config = function()
          require("telescope").load_extension "frecency"
        end,
        dependencies = { "kkharji/sqlite.lua" },
      },

      "nvim-telescope/telescope-fzy-native.nvim",
    },
    cmd = "Telescope",
        -- stylua: ignore
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
            { "<leader>fg", "<cmd>Telescope git_files<cr>",  desc = "Git Files" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>",    desc = "Buffers" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>",  desc = "Help" },

            { "<leader>fo",  "<cmd>lua require('config.telescope').oldfiles()<cr>",  desc = "frecency" },
            { "<leader>fr",  "<cmd>lua require('config.telescope').redis_list()<cr>",  desc = "Redis" },
            { "<leader>E",   "<cmd>lua require('config.telescope').my_examples()<cr>",  desc = "My Examples" },

            -- search
            { "<leader>fsg", "<cmd>lua require('config.telescope').grep_prompt()<cr>",  desc = "Grep" },
            { "<leader>fsl", "<cmd>lua require('config.telescope').live_grep()<cr>",  desc = "Live Grep" },
            -- projects
            -- { "<leader>fps", "<cmd>lua require('config.telescope').project_search()<cr>",  desc = "Project search" },
            -- neovim
            { "<leader>fna", "<cmd>lua require('config.telescope').edit_neovim(\"after\")<cr>",  desc = "after" },
            { "<leader>fnp", "<cmd>lua require('config.telescope').installed_plugins()<cr>",  desc = "Project search" },
            { "<leader>fnl", "<cmd>lua require('config.telescope').edit_neovim(\"lua\")<cr>",  desc = "Lua" },
            { "<leader>M",   "<cmd>lua require('config.telescope').man_pages()<cr>",  desc = "man pages" },
            -- { "<leader>/", "<cmd>lua require('config.telescope').search_all_files()<cr>",  desc = "rg search" },

            { "<leader>sd",   "<cmd>lua require('config.telescope').short_docs()<cr>",  desc = "Short docs" },
            { "<leader>ldoc", "<cmd>lua require('config.telescope').edit_ldoc()<cr>",  desc = "ldocs" },
            { "<leader>pdoc", "<cmd>lua require('config.telescope').edit_pdoc()<cr>",  desc = "pdocs" },

        },

    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = function(...)
              require("telescope.actions").move_selection_next(...)
            end,
            ["<C-k>"] = function(...)
              require("telescope.actions").move_selection_previous(...)
            end,
            ["<C-n>"] = function(...)
              require("telescope.actions").cycle_history_next(...)
            end,
            ["<C-p>"] = function(...)
              require("telescope.actions").cycle_history_prev(...)
            end,
          },
        },
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        history = {
          path = vim.fn.stdpath "data" .. "/telescope_history.sqlite3",
          limit = 100,
        },
      },
    },
    config = function(_, opts)
      local telescope = require "telescope"
      telescope.setup(opts)
      telescope.load_extension "fzf"

      -- telescope.load_extension "aerial"
      telescope.load_extension "project" -- telescope-project.nvim
      telescope.load_extension "projects" -- project.nvim
      telescope.load_extension "neoclip"
      telescope.load_extension "dap"
      telescope.load_extension "notify"
      telescope.load_extension "file_browser"
      telescope.load_extension "ui-select"
      telescope.load_extension "yabs"
      telescope.load_extension "repo"
      telescope.load_extension "git_worktree"
      telescope.load_extension "refactoring"
      -- telescope.load_extension "todo-comments"
      -- _ = require("telescope").load_extension "flutter"

      telescope.load_extension "smart_history"
      telescope.load_extension "frecency"
      telescope.load_extension "advanced_git_search"
    end,
  },
}
