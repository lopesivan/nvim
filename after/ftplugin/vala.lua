vim.g.VimuxPromptString = "Vala"
vim.g.VimuxRunnerType = "window"
vim.g.VimuxRunnerName = "+Octave"
vim.g.VimuxCloseOnExit = 1

vim.g.projectionist_heuristics = {
  ["*.vala"] = {
    ["*.vala"] = {
      -- ["start"] = "vala {file|basename}",
      ["make"] = "valac {file}",
      -- ["run"] = 'lua require("config.nvim_dev").app("octave",{file})',
      ["async_run"] = "AsyncRun -mode=term -pos=tmux vala {file}",
      ["quit"] = "call VimuxCloseRunner()",
      ["run"] = "lua require('config.nvim_dev').app('vala',{'{file}'})",
      ["some_variable"] = "foo",
      ["type"] = "vala",
    },
  },
}
-- projectionist#query_scalar('some_variable')
-- nmenu Quarto.QuartoPreview  :exe " ".projectionist#query('QuartoPreview')[0][1]
-- echo projectionist#query_scalar('quit')[0]
-- function! projectionist#query_raw(key, ...) abort
-- function! projectionist#query_file(key, ...) abort
-- function! projectionist#query_exec(key, ...) abort
-- function! projectionist#query_scalar(key) abort
--
--
local nmap = require("config.dispatch").nmap
nmap { "<leader><CR>", "run", "nvim_dev Run" }
nmap { "<leader><leader><CR>", "async_run", "Async Run" }
nmap { "<leader><leader>q", "quit", "Close window" }
nmap { "m<CR>", "make", "Make" }
