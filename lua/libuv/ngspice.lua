local M = {}

local Terminal = require("toggleterm.terminal").Terminal

local cmd = "ngspice"

local command_client = Terminal:new {
  cmd = cmd,
  dir = string.format("%s", vim.fn.getcwd()),
  hidden = true,
  direction = "float",
  float_opts = {
    border = "double",
  },
}

function M.command_toggle()
  command_client:toggle()
end
--  FIXME: 💩   > esse trecho de código ativa o modifiable para on, assim
--  podemos interagir com o programa ao entrar no modo de inserção
local bufnr = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>i", true, false, true), "n", true)

return M
