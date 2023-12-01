local M = {}

local Terminal = require("toggleterm.terminal").Terminal

local cmd = "ipython"

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
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>i", true, false, true), "n", true)
end

return M
