-- python.lua
local set = vim.opt_local
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
set.textwidth = 78

set.expandtab = true
set.smarttab = true

-- fold
if false then
  set.foldcolumn = "1"
  set.foldenable = true
  set.foldmethod = "expr"
  -- set.foldexpr = "v:lua.vim.lsp.foldexpr()"
  set.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  set.foldtext = require("my.fold.python.foldtext")
end
-- vim.b.start="ipython -i %"

vim.b["surround_" .. vim.fn.char2nr("p")] = 'print ("\r")'
-- vim.b["surround_" .. vim.fn.char2nr "q"] = '"\r"'

vim.g.projectionist_heuristics = {
  ["*.py"] = {
    ["*.py"] = {
      ["start"] = "ipython -i {file}",
      ["make"] = "python {file}",
      ["run"] = "lua require('my.neovim_dev').app('python',{'{file}'})",
      ["pythonlog"] = "lua require('my.neovim_dev').applog('python', {'{file}'}, '{}.log')",
      ["type"] = "python",
    },
  },
}

local bufnr = vim.api.nvim_get_current_buf()
local dispatch_nmap = require("my.dispatch").nmap

dispatch_nmap(
  { "s<CR>", "start", "start", "Julia Interativo" },
  { buffer = bufnr }
)
dispatch_nmap(
  { "<leader><CR>", "run", "nvim_dev Run", "nvim_dev Run" },
  { buffer = bufnr }
)
dispatch_nmap(
  { "<leader><leader>l", "pythonlog", "python log", "python log" },
  { buffer = bufnr }
)
