vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.textwidth = 78

vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.smartcase = true
vim.opt.infercase = true

vim.opt.commentstring = "# %s"

vim.g.VimuxPromptString = "bash"
vim.g.VimuxRunnerType = "window"
vim.g.VimuxRunnerName = "+Bash"
vim.g.VimuxCloseOnExit = 1
vim.g.projectionist_heuristics = {
  ["*.sh"] = {
    ["*.sh"] = {
      ["dispatch"] = "bash {file}",
      ["make"] = "bash {file}",
      ["async_run"] = "AsyncRun -mode=term -pos=tmux bash {file|basename}",
      ["quit"] = "call VimuxCloseRunner()",
      -- roda o arquivo salvo
      ["run"] = "lua require('config.nvim_dev').sh({'{file|basename}'})",
      -- roda o que estiver definido em yabs.lua "sh"
      -- roda o buffer
      ["yabs"] = "run",
      ["type"] = "sh",
    },
  },
}
-- <CMD>lua require('config.nvim_dev').sh(vim.fn.expand("%"))<CR>
local nmap = require("config.dispatch").nmap
nmap { "<leader><CR>", "run", "nvim_dev Run" }
nmap { "<leader><leader><CR>", "async_run", "Async Run" }
nmap { "<leader><leader>q", "quit", "Close window" }
nmap { "r<CR>", "yabs", "Run" }
nmap { "m<CR>", "make", "Make" }
nmap { "d<CR>", "dispatch", "Dispatch" }

-- uso: comando ttr
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
  templates = { "builtin", "scripts" },
}
