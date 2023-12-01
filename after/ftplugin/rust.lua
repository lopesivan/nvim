-- Don't do comment stuffs when I use o/O
vim.opt_local.formatoptions:remove "o"

vim.g.VimuxPromptString = "rust"
vim.g.VimuxRunnerType = "window"
vim.g.VimuxRunnerName = "+RUST"
vim.g.VimuxCloseOnExit = 1

vim.g.projectionist_heuristics = {
    ["*.rs"] = {
        ["*.rs"] = {
            ["make"] = "cargo run",
            ["async_run"] = "AsyncRun -mode=term -pos=tmux cargo run",
            ["telescope"] = "Telescope yabs tasks",
            ["quit"] = "call VimuxCloseRunner()",
            ["run"] = "lua require('config.nvim_dev').app('cargo',{'run','{file|basename}'})",
            ["type"] = "rust",
        },
    },
}
local nmap = require("config.dispatch").nmap
--nmap { "b<CR>", "telescope", "build maneger" }
nmap { "<leader><CR>", "run", "nvim_dev Run" }
nmap { "<leader><leader><CR>", "async_run", "Async Run" }
nmap { "<leader><leader>q", "quit", "Close window" }
nmap { "m<CR>", "make", "Make" }
-- nmap {'d<CR>', 'dispatch', 'Dispatch'}
