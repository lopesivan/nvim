local M = {}

local Terminal = require("toggleterm.terminal").Terminal

local cmd = "ranger"

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

return M
