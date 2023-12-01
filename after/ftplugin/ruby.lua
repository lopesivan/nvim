-- ruby.lua - ruby
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

vim.g.VimuxPromptString = "ruby"
vim.g.VimuxRunnerType = "window"
vim.g.VimuxRunnerName = "+RUBY"
vim.g.VimuxCloseOnExit = 1
vim.g.projectionist_heuristics = {
    ["*.rb"] = {
        ["*.rb"] = {
            ["start"] = "irb -I . -r ./{file|basename}",
            ["make"] = "ruby {file}",
            ["run"] = "lua require('config.nvim_dev').app('ruby',{'{file}'})",
            ["dispatch"] = "ruby {file}",
            ["yabs_run"] = "run",
            ["yabs_debug"] = "debug",
            ["telescope"] = "Telescope yabs tasks",
            ["async_run"] = "AsyncRun -mode=term -pos=tmux ruby {file}",
            ["quit"] = "call VimuxCloseRunner()",
            ["type"] = "ruby",
        },
    },
}

local nmap = require("config.dispatch").nmap
--nmap { "b<CR>", "telescope", "build maneger" }
nmap { "<leader><CR>", "run", "nvim_dev Run" }
nmap { "s<CR>", "start", "Ipython" }
nmap { "m<CR>", "make", "Make" }
nmap { "<leader><leader><CR>", "async_run", "Async Run" }
nmap { "<leader><leader>q", "quit", "Close window" }
nmap { "r<CR>", "yabs_run", "Run" }
nmap { "d<CR>", "yabs_debug", "Debug" }

-- vim: fdm=marker:sw=4:sts=4:et
