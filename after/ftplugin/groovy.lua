vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.textwidth = 78
vim.bo.expandtab = true
vim.bo.autoindent = true

vim.opt.formatoptions = vim.opt.formatoptions - "o" -- O and o, don't continue comments


vim.g.VimuxPromptString = "groovy"
vim.g.VimuxRunnerType = "window"
vim.g.VimuxRunnerName = "+GROOVY"
vim.g.VimuxCloseOnExit = 1
vim.g.projectionist_heuristics = {
    ["*.groovy"] = {
        ["*.groovy"] = {
            ["run"] = "lua require('config.nvim_dev').app('groovy',{'{file}'})",
            ["async_run"] = "AsyncRun -mode=term -pos=tmux groovy {file}",
            ["quit"] = "call VimuxCloseRunner()",
            ["type"] = "groovy",
        },
    },
}

local nmap = require("config.dispatch").nmap
nmap { "<leader><CR>", "run", ":groovy file" }
nmap { "<leader><leader><CR>", "async_run", "Async Run" }
nmap { "<leader><leader>q", "quit", "Close window" }

vim.env.JAVA_HOME="/home/ivan/.jenv/versions/19"
-- os.setenv("JAVA_HOME", "/caminho/para/java/home")
