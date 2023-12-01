-- javascript.lua - javascript
-- Maintainer: Ivan Lopes
-- ~/.config/nvim/after/plugin

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.textwidth = 78

vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.smartcase = true
vim.opt.infercase = true

vim.g.VimuxPromptString = "javascript"
vim.g.VimuxRunnerType = "window"
vim.g.VimuxRunnerName = "+JAVASCRIPT"
vim.g.VimuxCloseOnExit = 1
vim.g.projectionist_heuristics = {
  ["*.js"] = {
    ["*.js"] = {
      ["start"] = "node ./{file|basename}",
      ["make"] = "node {file}",
      ["run"] = "lua require('config.nvim_dev').app('node',{'{file}'})",
      ["dispatch"] = "node {file}",
      ["async_run"] = "AsyncRun -mode=term -pos=tmux node {file}",
      ["quit"] = "call VimuxCloseRunner()",
      ["type"] = "javascript",
    },
  },
}

local nmap = require("config.dispatch").nmap
nmap { "<leader><CR>", "run", "nvim_dev Run" }
nmap { "s<CR>", "start", "Node" }
nmap { "m<CR>", "make", "Make" }
nmap { "<leader><leader><CR>", "async_run", "Async Run" }
nmap { "<leader><leader>q", "quit", "Close window" }

-- vim: fdm=marker:sw=4:sts=4:et
