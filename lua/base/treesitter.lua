return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/playground",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      sync_install = false,
      ensure_installed = {
        "bash",
        "dockerfile",
        "html",
        "markdown",
        "markdown_inline",
        "org",
        "query",
        "regex",
        "latex",
        "vim",
        "vimdoc",
        "yaml",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "org", "markdown" },
      },
      indent = { enable = true },
      -- context_commentstring = { enable = true, enable_autocmd = false },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "|",
          node_incremental = "|",
          scope_incremental = "<tab>",
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        move = {
          enable = true,
          disable = { "ruby" },
          set_jumps = true,
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
          -- ----------------------------------------------------------
          --
          --       Alt BSP Alt p
          --       ' ---<---`
          --      /          \
          --   (arg1, arg2, ..., argN)
          --      \          /
          --       ' --->---`
          --        Alt SPC Alt p
          --
          -- ----------------------------------------------------------
          --
          --                         [[  up
          --                         ]]  down
          --              -------------
          --       .-----.
          --       |Class|
          --       '-----'
          --              -------------
          --                          [] up
          --                          ][ down
          --
          -- ----------------------------------------------------------
          --
          --                         [m  up
          --                         ]m  down
          --            -------------
          --       .---.
          --       |FUN|
          --       '---'
          --            -------------
          --                         [M  up
          --                         ]M  down
          --
          -- ----------------------------------------------------------

          -- * Alt SPC Alt p argfun ->                          [treesiter]
          -- * Alt BSP Alt p <- argfun                          [treesiter]
          -- * ]m            go fun <UP>            HEAD        [treesiter]
          -- * [m            go fun <DOWN>          HEAD        [treesiter]
          -- * [M            go fun end <UP>        TAIL        [treesiter]
          -- * ]M            go fun end <DOWN>      TAIL        [treesiter]
          -- * [[            go class <UP>          HEAD        [treesiter]
          -- * ]]            go class <DOWN>        HEAD        [treesiter]
          -- * ][            go end class <UP>      TAIL        [treesiter]
          -- * []            go end class <DOWN>    TAIL        [treesiter]
          -- * v a f         Visual ALL func                    [treesiter]
          -- * v i f         Visual INNER func                  [treesiter]
          -- * v a c         Visual ALL class                   [treesiter]
          -- * v i c         Visual INNER class                 [treesiter]
          -- * v a a         Visual ALL arg                     [treesiter]
          -- * v i a         Visual INNER arg                   [treesiter]
          --
        },
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
      },
      matchup = {
        enable = true,
      },
    },
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        ---@type table<string, boolean>
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then
            return false
          end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
