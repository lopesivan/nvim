vim.opt.tabstop     = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth  = 4
vim.opt.textwidth   = 78

vim.opt.expandtab   = true
vim.opt.wrap        = false
vim.opt.smartcase   = true
vim.opt.infercase   = true

vim.opt.commentstring = "# %s"

vim.g.VimuxPromptString = "awk"
vim.g.VimuxRunnerType = "window"
vim.g.VimuxRunnerName = "+AWK"
vim.g.VimuxCloseOnExit = 1
vim.g.projectionist_heuristics = {
  ['*.awk'] = {
    ['*.awk'] = {
      ['dispatch'] = "awk -f {file|basename} <<< '\\n'",
      ['make'] = "awk -f {file|basename} <<< '\\n'",
      ['async_run'] = "AsyncRun -mode=term -pos=tmux awk -f {file|basename} <<< '\\n'",
      ['quit'] = 'call VimuxCloseRunner()',
      ['type'] = 'awk'
    }
  }
}

local nmap = require("config.dispatch").nmap
nmap {'<leader><CR>', 'async_run', 'Async Run'}
nmap {'<leader><leader>q', 'quit', 'Close window'}
nmap {'m<CR>', 'make', 'Make'}
nmap {'d<CR>', 'dispatch', 'Dispatch'}
