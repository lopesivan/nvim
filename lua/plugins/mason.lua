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

  -- LSPs (nomes do lspconfig)
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
          "lua_ls",
          "clangd",
          "jdtls",
          "marksman",
          "pyright",
          "ruff",
          "glsl_analyzer",
        },
      })
    end,
  },

  -- Pacotes que não são LSP (DAP, formatters) + garantia de todos (nomes do Mason)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    cmd = { "MasonToolsInstall", "MasonToolsUpdate", "MasonToolsClean" },
    dependencies = { "mason-org/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "glsl_analyzer",
          "autopep8",
          "bash-debug-adapter",
          "black",
          "clangd",
          "codelldb",
          "google-java-format",
          "jdtls",
          "lua-language-server",
          "marksman",
          "prettier",
          "pyright",
          "roslyn-nightly",
          "ruff",
        },
        auto_update = false,
        run_on_start = true,
        start_delay = 1000,
      })
    end,
  },
}
