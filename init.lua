vim.g.mapleader = " " -- set space as leader
vim.g.maplocalleader = " " -- Set space as local leader

require("config.lazy")
require("config.keymaps")
require("config.options")
require("config.commands")
require("my.terminal")
require("my.file-explorer")
require("my.file-search")

vim.lsp.enable("lua_ls")
vim.lsp.enable("astro")
vim.lsp.enable("ts_ls")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("jdtls")
vim.lsp.enable("kotlin_lsp")
vim.lsp.enable("lemminx")
vim.lsp.enable("clangd")
vim.lsp.enable("glsl_analyzer")
vim.lsp.enable("jsonls")
-- vim.lsp.enable("html-lsp")
vim.lsp.enable("html") -- era "html-lsp"
vim.lsp.enable("pyright")
vim.lsp.enable("ruff")
vim.lsp.enable("marksman")

-- vim.lsp.enable('tailwindcss')

vim.fn.setenv("DAP_LOG_LEVEL", "TRACE")
vim.fn.setenv("DAP_LOG_FILE", vim.fn.stdpath("cache") .. "/dap.log")

-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
