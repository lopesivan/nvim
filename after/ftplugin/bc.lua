
--[[
let g:projectionist_heuristics = {
      \   '*.bc': {
      \     '*.bc': {
      \       'make': 'bc -q {file} <<< "quit"',
      \       'dispatch': 'bc -q {file}',
      \       'type': 'bc'
      \     }
      \   }
      \ }
--]]

vim.opt.commentstring = "# %s"

vim.g.VimuxPromptString = "bc"
vim.g.VimuxRunnerType = "window"
vim.g.VimuxRunnerName = "+bc"
vim.g.VimuxCloseOnExit = 1
vim.g.projectionist_heuristics = {
  ['*.bc'] = {
    ['*.bc'] = {
      ['make'] = 'bc -q -l {file} <<< "quit" >{}.out',
      ['dispatch'] = 'bc -q -l {file} <<< "quit" >{}.out',
      ['async_run'] = "AsyncRun -mode=term -pos=tmux bc -l -q {file|basename}  <<<'quit'",
	  ['yabs']= 'run',
      ['quit'] = 'call VimuxCloseRunner()',
      ['run'] = 'lua require(\'config.nvim_dev\').app(\'bc\',{\'-q\',\'-l\',\'{file|basename}\'})',
      ['type'] = 'bc'
    }
  }
}

local nmap = require("config.dispatch").nmap
nmap {'<leader><leader><CR>', 'async_run', 'Async Run'}
nmap {'<leader><leader>q', 'quit', 'Close window'}
nmap {'<leader><CR>', 'run', 'nvim_dev Run'}
nmap {'r<CR>', 'yabs', 'Run'}
nmap {'m<CR>', 'make', 'Make'}
nmap {'d<CR>', 'dispatch', 'Dispatch'}

