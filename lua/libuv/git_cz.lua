local M = {}

local Terminal = require("toggleterm.terminal").Terminal

local cmd = "git cz"

local command_client = Terminal:new {
    cmd = cmd,
    dir = string.format("%s", vim.fn.getcwd()),
    hidden = true,
    float_opts = {
        border = "double",
    },
}

function M.command_toggle()
    command_client:toggle()
end

return M
