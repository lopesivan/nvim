if not require("config").pde.yaml then
  return {}
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "matlab" })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "matlab-language-server" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        matlab_ls = {
          single_file_support = true,
          settings = {
            matlab = {
              installPath = "/opt/R2020b//",
              matlabConnectionTiming = "onStart",
              telemetry = true,
            },
          },
        },
      },
    },
  },

  -- {
  --   "nvimtools/none-ls.nvim",
  --   opts = function(_, opts)
  --     local nls = require "null-ls"
  --     table.insert(opts.sources, nls.builtins.diagnostics.mlint)
  --   end,
  -- },
}
