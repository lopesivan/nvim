-- spice.lua - spice
-- Maintainer: Ivan Lopes
-- ~/.config/nvim/after/plugin

vim.opt.commentstring = "* %s"

vim.g.VimuxPromptString = "ngspice"
vim.g.VimuxRunnerType = "window"
vim.g.VimuxRunnerName = "+NGSpice"
vim.g.VimuxCloseOnExit = 1

vim.g.projectionist_heuristics = {
  ["*.sp"] = {
    ["*.sp"] = {
      ["start"] = "ngspice {file|basename}",
      ["dispatch"] = "ngspice -b {file} >{}.out",
      ["make"] = "ngspice -b {file}",
      ["async_run"] = "AsyncRun -mode=term -pos=tmux ngspice -b {file|basename}",
      ["quit"] = "call VimuxCloseRunner()",
      ["run"] = "lua require('config.nvim_dev').app('ngspice',{'-b','{file|basename}'})",
      ["type"] = "spice",
    },
  },
}

local nmap = require("config.dispatch").nmap
nmap { "s<CR>", "start", "NGSpice Interativo" }
nmap { "<leader><CR>", "run", "nvim_dev Run" }
nmap { "<leader><leader><CR>", "async_run", "Async Run" }
nmap { "<leader><leader>q", "quit", "Close window" }
nmap { "d<CR>", "dispatch", "Dispatch" }
-- vim: fdm=marker:sw=4:sts=4:et
