vim.opt.commentstring = "# %s"
-- vim.opt.errorformat = '%+I%.%#'

vim.g.VimuxPromptString = "maple"
vim.g.VimuxRunnerType = "window"
vim.g.VimuxRunnerName = "+Maple"
vim.g.VimuxCloseOnExit = 1

vim.g.projectionist_heuristics = {
  ["*.mv"] = {
    ["*.mv"] = {
      ["dispatch"] = "maple -q {file} >{}.out",
      ["make"] = "maple -q {file}",
      ["start"] = "maple -i {file|basename}",
      ["async_run"] = "AsyncRun -mode=term -pos=tmux maple -q {file|basename}",
      ["quit"] = "call VimuxCloseRunner()",
      ["run"] = "lua require('config.nvim_dev').app('maple',{'-q','{file|basename}'})",
      ["yabs"] = "run",
      ["type"] = "maple",
    },
  },
}

local nmap = require("config.dispatch").nmap
nmap { "<leader><CR>", "run", "nvim_dev Run" }
nmap { "<leader><leader><CR>", "async_run", "Async Run" }
nmap { "<leader><leader>q", "quit", "Close window" }
nmap { "r<CR>", "yabs", "Run" }
nmap { "m<CR>", "make", "Make" }
nmap { "d<CR>", "dispatch", "Dispatch" }
nmap { "s<CR>", "start", "Maple Interativo" }

vim.g.easy_align_delimiters = {
  -- aperto <
  ["="] = {
    ["pattern"] = ":=",
    ["ignore_groups"] = { "String" },
    ["ignore_unmatched"] = 0,
  },
}
-- local filename = vim.fn.expand "%"
-- vim.b.start = string.format("maple -i %s", filename)
