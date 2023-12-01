--[[
" ----------------------------------------------------------------------------
" <F5>
" set makeprg=haml\ -f\ html5\ %\ >\ %<.html
" <F9>
" let b:start = 'haml -f html5 '.expand('%').' '.expand('%:r').'.html'
" <F10>
" let b:dispatch = 'faml render '.expand('%')
" ----------------------------------------------------------------------------
let g:projectionist_heuristics = {
      \   '*.haml': {
      \     '*.haml': {
      \       'make': 'haml --double-quote-attributes -f xhtml {file} {}.xml',
      \       'dispatch': 'faml render {file} >{}.xml',
      \       'type': 'haml'
      \     }
      \   }
      \ }
--]]

-- vim.g.projectionist_heuristics = {
--     ["*.haml"] = {
--         ["*.haml"] = {
--             ["make"] = "haml --double-quote-attributes -f xhtml {file} {}.xml",
--             ["dispatch"] = "faml render {file} >{}.xml",
--             ["type"] = "haml",
--         },
--     },
-- }

vim.g.VimuxPromptString = "haml"
vim.g.VimuxRunnerType = "window"
vim.g.VimuxRunnerName = "+HAML"
vim.g.VimuxCloseOnExit = 1

vim.g.projectionist_heuristics = {
    ["*.haml"] = {
        ["*.haml"] = {
            ["make"] = "haml --double-quote-attributes -f xhtml {file} {}.xml",
            ["async_run"] = "AsyncRun -mode=term -pos=tmux haml --double-quote-attributes -f xhtml {file} {}.xml",
            ["quit"] = "call VimuxCloseRunner()",
            ["run"] = "lua require('config.nvim_dev').app('haml',{'--double-quote-attributes','{file|basename}'})",
            ["type"] = "haml",
        },
    },
}
local nmap = require("config.dispatch").nmap
nmap { "<leader><CR>", "run", "nvim_dev Run" }
nmap { "<leader><leader><CR>", "async_run", "Async Run" }
nmap { "<leader><leader>q", "quit", "Close window" }
nmap { "m<CR>", "make", "Make" }
-- nmap {'d<CR>', 'dispatch', 'Dispatch'}
