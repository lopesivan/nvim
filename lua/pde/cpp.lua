if not require("config").pde.cpp then
  return {}
end

local function get_codelldb()
  local mason_registry = require "mason-registry"
  local codelldb = mason_registry.get_package "codelldb"
  local extension_path = codelldb:get_install_path() .. "/extension/"
  local codelldb_path = extension_path .. "adapter/codelldb"
  local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
  return codelldb_path, liblldb_path
end

return {
  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "c", "cpp" })
    end,
  },
  -- Mason
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "codelldb", "clangd" })
    end,
  },
  -- null ls
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require "null-ls"
      -- table.insert(opts.sources, nls.builtins.formatting.clang_format)
      -- Arquivo de configuração do astyle
      -- /home/ivan/.config/astyle/astylerc
      -- table.insert(opts.sources, nls.builtins.formatting.astyle)
    end,
    ft = { "c", "cpp" },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "p00f/clangd_extensions.nvim" },
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
        }, -- clangd
      },
      setup = {
        clangd = function(_, _)
          local lsp_utils = require "base.lsp.utils"
          lsp_utils.on_attach(function(client, bufnr)
            local map = function(mode, lhs, rhs, desc)
              if desc then
                desc = desc
              end
              vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
            end
            -- stylua: ignore
            if client.name == "clangd" then
                map("n", "<leader>lt", "<cmd>ClangdSwitchSourceHeader<cr>",  "Clang Switch Source Header" )
                map("x", "<leader>lA", "<cmd>ClangdAST<cr>",  "Clang View AST" )
                map("n", "<leader>li", "<cmd>ClangdSymbolInfo<cr>",  "Clang Symbol Info" )
                map("n", "<leader>lh", "<cmd>ClangdTypeHierarchy<cr>",  "Clang Type Hierarchy" )
                map("n", "<leader>lm", "<cmd>ClangdMemoryUsage<cr>",  "Clang Memory Usage" )
            end

            require("clangd_extensions.inlay_hints").setup_autocmd()
            require("clangd_extensions.inlay_hints").set_inlay_hints()
          end)
        end,
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    opts = {
      setup = {
        codelldb = function()
          local codelldb_path, _ = get_codelldb()
          local dap = require "dap"
          dap.adapters.codelldb = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
              command = codelldb_path,
              args = { "--port", "${port}" },

              -- On windows you may have to uncomment this:
              -- detached = false,
            },
          }
          dap.configurations.cpp = {
            {
              name = "Launch file",
              type = "codelldb",
              request = "launch",
              program = function()
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
              end,
              cwd = "${workspaceFolder}",
              stopOnEntry = false,
            },
          }

          dap.configurations.c = dap.configurations.cpp
          dap.configurations.rust = dap.configurations.cpp
        end,
      },
    },
  },
  {
    "nvim-cmp",
    opts = function(_, opts)
      table.insert(opts.sorting.comparators, 1, require "clangd_extensions.cmp_scores")
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      { "alfaix/neotest-gtest", opts = {} },
    },
    opts = function(_, opts)
      vim.list_extend(opts.adapters, {
        require "neotest-gtest",
      })
    end,
  },
}
