-- programa em lua

vim.g.quickmenu_options = "HL"
vim.cmd [[
nmenu Go.Start  :exe " ".projectionist#query('start')[0][1]
nmenu Go.Stop   :exe " ".projectionist#query('stop')[0][1]
nmenu Go.Toggle :exe " ".projectionist#query('toggle')[0][1]
nmenu Go.toHTML :lua require'libuv.markdown'.convertFile()
nmenu Go.Slide  :lua require'telegraph'.telegraph({cmd='lookatme {filepath} --live-reload --style gruvbox-dark', how='tmux'})
]]

-- vim.api.nvim_set_keymap("n", "<space>0", "<Cmd>call projectionist#activate()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<F12>", "<Cmd>call Menu2Quick('Go', 'n')<CR>", { noremap = true, silent = true })

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
  templates = { "builtin", vim.bo.filetype },
}

vim.g.VimuxPromptString = "go"
vim.g.VimuxRunnerType = "window"
vim.g.VimuxRunnerName = "+GO"
vim.g.VimuxCloseOnExit = 1

vim.g.projectionist_heuristics = {
  ["*.go"] = {
    ["*.go"] = {
      ["make"] = "go run {file}",
      ["async_run"] = "AsyncRun -mode=term -pos=tmux go run {file}",
      ["quit"] = "call VimuxCloseRunner()",
      ["run"] = "lua require('config.nvim_dev').app('go',{'run','{file|basename}'})",
      ["type"] = "go",
    },
  },
}
local nmap = require("config.dispatch").nmap
--nmap { "b<CR>", "telescope", "build maneger" }
nmap { "<leader><CR>", "run", "nvim_dev Run" }
nmap { "<leader><leader><CR>", "async_run", "Async Run" }
nmap { "<leader><leader>q", "quit", "Close window" }
nmap { "m<CR>", "make", "Make" }

-- vim.fn["edit_alternate#rule#add"]("go", function(filename)
--   if filename:find "_test.go" then
-- 	return (filename:gsub("_test%.go", ".go"))
--   else
-- 	return (filename:gsub("%.go", "_test.go"))
--   end
-- end)
