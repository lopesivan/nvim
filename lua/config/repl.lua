if false then
    RELOAD "config.repl"
end

local M = {}

_ReplCurrentJobID = _ReplCurrentJobID or -1
_ReplCurrentCommand = _ReplCurrentCommand or nil

M.set_job_id = function(job_id)
    job_id = job_id or vim.b.terminal_job_id

    print("setting job id..", job_id)
    _ReplCurrentJobID = job_id
end

M.set_command = function(command)
    local bufnr = vim.api.nvim_get_current_buf()
    local start_line, end_line, cursor_position

    cursor_position = vim.api.nvim_win_get_cursor(0)
    start_line = cursor_position[1] - 1
    end_line = cursor_position[1] - 1
    local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line + 1, false)
    command = table.concat(lines, "\n")
    vim.fn.chansend(_ReplCurrentJobID, command .. "\n")
end

M.set_vcommand = function(command)
    local bufnr = vim.api.nvim_get_current_buf()
    local start_pos = vim.api.nvim_buf_get_mark(bufnr, '<')
    local end_pos = vim.api.nvim_buf_get_mark(bufnr, '>')
    local start_line = start_pos[1] - 1
    local end_line = end_pos[1] - 1

    local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line + 1, false)
    command = table.concat(lines, "\n")
    vim.fn.chansend(_ReplCurrentJobID, command .. "\n")
end

M.set_job_command = function(command)
    _ReplCurrentCommand = command or vim.fn.input "Send to chan >"
end

M.send_to_term = function(input)
    input = input or _ReplCurrentCommand or vim.fn.input "Send to chan >"

    vim.fn.chansend(_ReplCurrentJobID, { input .. "\r\n" })
end

return M
