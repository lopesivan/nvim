local M = {}

_TERM = -1
_PROMPT_BUFFER = -1

local console = function(cmd)
    local shell =
        string.format("bash --rcfile %s/bashrc", vim.fn.stdpath "config")

    local term = nil

    local OK = false

    if (_TERM == -1) and (_PROMPT_BUFFER == -1) then
        OK = true
    else
        if #vim.fn.getbufinfo(_PROMPT_BUFFER) == 0 then
            _TERM = -1
            _PROMPT_BUFFER = -1
            OK = true
        end
    end

    if OK then
        vim.cmd [[20new]]
        term = vim.fn.termopen(shell)
        vim.wait(100, function()
            return false
        end)

        _TERM = term

        local closing_keys = { "q" }
        local map_options = {
            noremap = true,
            silent = true,
        }

        for _, key in ipairs(closing_keys) do
            vim.api.nvim_buf_set_keymap(
                vim.api.nvim_get_current_buf(),
                "n",
                key,
                "<CMD>q!<CR>",
                map_options
            )
        end
    else
        term = _TERM
    end

    if OK then
        local buf = vim.api.nvim_get_current_buf()
        _PROMPT_BUFFER = buf
    end

    local data = cmd .. "\n"
    vim.api.nvim_chan_send(term, data)
end
local cmd = "pythagoras"

function M.command_toggle()
    vim.ui.input({ prompt = "pythagoras input: " }, function(input)
        local cmd = "pythagoras"
        if input == "" or not input then
            return
        elseif input == "-h" then
            cmd = ""
        else
            cmd = cmd .. " " .. input
        end
        console(cmd)
    end)
end

return M
