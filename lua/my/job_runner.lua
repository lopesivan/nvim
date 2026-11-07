-- job_runner.lua
local Job = require "plenary.job"
local float_win = require "plenary.window.float"

local JobRunner = {}
JobRunner.__index = JobRunner

function JobRunner:new(cmd, args, logfile)
    local obj = setmetatable({}, self)
    obj.command = cmd
    obj.args = args or {}
    obj.logfile = logfile
    obj.output = {}
    return obj
end

function JobRunner:_open_float()
    self.float = float_win.percentage_range_window(0.9, 0.8)
    self.count = 0

    vim.bo[self.float.bufnr].buftype = "nofile"
    vim.bo[self.float.bufnr].bufhidden = "wipe"
    vim.bo[self.float.bufnr].swapfile = false

    local closing_keys = { "q", "<Esc>", "<CR>" }
    local opts = { noremap = true, silent = true }

    for _, key in ipairs(closing_keys) do
        vim.api.nvim_buf_set_keymap(self.float.bufnr, "n", key, "<CMD>close!<CR>", opts)
    end
end

function JobRunner:_append_to_buffer(line)
    if not self.float or not vim.api.nvim_buf_is_valid(self.float.bufnr) then
        return
    end

    vim.bo[self.float.bufnr].modifiable = true

    vim.api.nvim_buf_set_lines(
        self.float.bufnr,
        self.count,
        self.count,
        false,
        { line }
    )

    self.count = self.count + 1
end

function JobRunner:_finalize_buffer()
    vim.bo[self.float.bufnr].readonly = true
    vim.bo[self.float.bufnr].buftype = "nofile"
    vim.bo[self.float.bufnr].modified = false
    vim.bo[self.float.bufnr].modifiable = false

    if self.float.win_id and vim.api.nvim_win_is_valid(self.float.win_id) then
        vim.api.nvim_set_option_value("wrap", false, { win = self.float.win_id })
    end
end

function JobRunner:_save_output()
    if not self.logfile then return end

    local file = io.open(self.logfile, "w")
    if not file then
        vim.notify("Erro ao abrir arquivo de log: " .. self.logfile, vim.log.levels.ERROR)
        return
    end

    for _, line in ipairs(self.output) do
        file:write(line .. "\n")
    end
    file:close()
    vim.notify("Saída salva em: " .. self.logfile, vim.log.levels.INFO)
end

function JobRunner:start()
    self:_open_float()

    Job:new({
        command = self.command,
        args = self.args,

        on_stdout = vim.schedule_wrap(function(_, data)
            if not data or data == "" then return end
            self:_append_to_buffer(data)
            table.insert(self.output, data)
        end),

        on_stderr = vim.schedule_wrap(function(_, data)
            if not data or data == "" then return end
            local line = "stderr: " .. data
            self:_append_to_buffer(line)
            table.insert(self.output, line)
        end),

        on_exit = vim.schedule_wrap(function(job, code)
            if code ~= 0 then
                -- usa self.output que já tem stdout + stderr em ordem
                vim.fn.setqflist({}, "a", {
                    title = "Job Errors",
                    items = vim.tbl_map(function(line)
                        return { text = line }
                    end, self.output),
                })
            end
            self:_save_output()
            self:_finalize_buffer()
        end),
    }):start()
end

return JobRunner
