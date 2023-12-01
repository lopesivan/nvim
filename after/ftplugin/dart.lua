vim.opt.commentstring = "# %s"
-- vim.opt.errorformat = '%+I%.%#'

vim.g.VimuxPromptString = "dart"
vim.g.VimuxRunnerType = "window"
vim.g.VimuxRunnerName = "+Dart"
vim.g.VimuxCloseOnExit = 1

vim.g.projectionist_heuristics = {
  ["*.dart"] = {
    ["*.dart"] = {
      ["async_run"] = "AsyncRun -mode=term -pos=tmux dart {file|basename}",
      ["quit"] = "call VimuxCloseRunner()",
      ["run"] = "lua require('config.nvim_dev').app('dart',{'{file|basename}'})",
      ["yabs"] = "run",
      ["type"] = "dart",
    },
  },
}

local status_ok, flutter = pcall(require, "flutter-tools")
if not status_ok then
  return
end
flutter.setup {} -- use defaults

local nmap = require("config.dispatch").nmap
nmap { "<leader><CR>", "run", "nvim_dev Run" }
nmap { "<leader><leader><CR>", "async_run", "Async Run" }
nmap { "<leader><leader>q", "quit", "Close window" }

-- local filename = vim.fn.expand "%"
-- vim.b.start = string.format("dart -i %s", filename)
