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

vim.g.VimuxPromptString = "typescript"
vim.g.VimuxRunnerType = "window"
vim.g.VimuxRunnerName = "+TYPESCRIPT"
vim.g.VimuxCloseOnExit = 1
vim.g.projectionist_heuristics = {
  ["*.ts"] = {
    ["*.ts"] = {
      ["alternate"] = "build/src/{}.js",
      ["start"] = "npm run start",
      ["make"] = "npm run compile",
      ["run"] = "lua require('config.nvim_dev').app('npx', {'ts-node','{file}'})",
      ["dispatch"] = "npm run app",
      ["async_run"] = "AsyncRun -mode=term -pos=tmux npm run app",
      ["quit"] = "call VimuxCloseRunner()",
      ["type"] = "typesctipt",
    },
  },
}

local nmap = require("config.dispatch").nmap
nmap { "<leader><CR>", "run", "nvim_dev Run" }
nmap { "s<CR>", "start", "node" }
nmap { "d<CR>", "dispatch", "Dispatch" }
nmap { "m<CR>", "make", "Make" }
nmap { "<leader><leader><CR>", "async_run", "Async Run" }
nmap { "<leader><leader>q", "quit", "Close window" }

require("overseer").setup {
  strategy = {
    "toggleterm",
    -- load your default shell before starting the task
    use_shell = true,
    -- overwrite the default toggleterm "direction" parameter
    direction = "horizontal",
    close_on_exit = false,
    -- open the toggleterm window when a task starts
    open_on_start = true,
    -- mirrors the toggleterm "hidden" parameter, and keeps the task from
    -- being rendered in the toggleable window
    hidden = false,
  },
  dap = true,
  auto_scroll = true,
  close_on_exit = false,
  open_on_start = true,
  templates = { "builtin", vim.bo.filetype },
}
-- vim: fdm=marker:sw=4:sts=4:et
