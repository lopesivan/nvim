return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",

    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },
      "aaronhallaert/advanced-git-search.nvim",
      "nvim-telescope/telescope-dap.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "lopesivan/telescope-project.nvim",
      "nvim-telescope/telescope-smart-history.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      {
        "AckslD/nvim-neoclip.lua",
        config = function()
          require("neoclip").setup()
        end,
      },
      {
        "nvim-telescope/telescope-frecency.nvim",
        dependencies = { "kkharji/sqlite.lua" },
      },
    },

    opts = function()
      local actions = require("telescope.actions")
      local previewers = require("telescope.previewers")

      return {
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
            },
          },
          file_previewer = previewers.vim_buffer_cat.new,
          grep_previewer = previewers.vim_buffer_vimgrep.new,
          qflist_previewer = previewers.vim_buffer_qflist.new,
          history = {
            path = vim.fn.stdpath("data") .. "/telescope_history.sqlite3",
            limit = 100,
          },
        },
        extensions = {
          fzf = {},
          frecency = {
            db_safe_mode = false,
          },
        },
      }
    end,

    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      for _, ext in ipairs({
        "yabs",
        "project",
        "neoclip",
        "fzf",
        "dap",
        "file_browser",
        "ui-select",
        "refactoring",
        "todo-comments",
        "smart_history",
        "harpoon",
        "frecency",
        "advanced_git_search",
      }) do
        pcall(telescope.load_extension, ext)
      end
    end,

    keys = function()
      local function tmap(fn, mode)
        return function()
          require("my.telescope")[fn](mode)
        end
      end

      return {
        -- find files
        {
          "<leader><leader>f",
          tmap("find_files", "cwd"),
          desc = "find files",
        },
        {
          "<leader><leader>/",
          tmap("live_grep", "cwd"),
          desc = "Grep",
        },
        {
          "<leader>ff",
          tmap("find_files", "root"),
          desc = "find files root",
        },
        {
          "<leader>gg",
          function()
            require("telescope.builtin").git_files()
          end,
          desc = "Git Files",
        },
        {
          "<leader>fo",
          function()
            require("my.telescope").oldfiles()
          end,
          desc = "frecency",
        },
        {
          "<leader>fr",
          function()
            require("my.telescope").redis_list()
          end,
          desc = "Redis",
        },
        {
          "<leader>E",
          function()
            require("my.telescope").my_examples()
          end,
          desc = "My Examples",
        },
        {
          "<leader><leader>l",
          function()
            require("my.ripgrep").run()
          end,
          desc = "Live Grep with shortcuts",
        },
      }
    end,
  },
}
