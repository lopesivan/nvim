return {
  {
    "mason-org/mason.nvim",
    lazy = true,
    config = function()
      require("mason").setup({
        registries = {
          "github:Crashdummyy/mason-registry",
          "github:mason-org/mason-registry",
        },
        ui = {
          icons = {
            package_installed = "💊",
            package_pending = "💚",
            package_uninstalled = "💔",
          },
        },
      })
    end,
  },

  -- Servidores LSP
  {
    "mason-org/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "bashls",
          "clangd",
          "glsl_analyzer",
          "jdtls",
          "jsonls",
          "lua_ls",
          "marksman",
          "pyright",
          "ruff",
        },
        automatic_enable = false,
      })
    end,
  },

  -- Formatadores, linters e depuradores
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    cmd = {
      "MasonToolsInstall",
      "MasonToolsUpdate",
      "MasonToolsClean",
    },
    dependencies = {
      "mason-org/mason.nvim",
    },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Python
          "autopep8",
          "black",

          -- Java
          "google-java-format",

          -- JavaScript / JSON / HTML / CSS
          "prettier",

          -- Shell
          "shfmt",

          -- XML
          "xmlformatter",

          -- Debuggers
          "bash-debug-adapter",
          "codelldb",

          -- C# (registro personalizado)
          "roslyn-nightly",
        },
        auto_update = false,
        run_on_start = true,
        start_delay = 1000,
      })
    end,
  },
}
