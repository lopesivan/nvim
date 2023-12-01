local Path = require "plenary.path"
local Job = require "plenary.job"

local lspconfig_util = require "lspconfig.util"

local cached_configs = {}

local root_finder = lspconfig_util.root_pattern ".git"
local astyle_finder = function(path)
    if cached_configs[path] == nil then
        local file_path = Path:new(path)
        local root_path = Path:new(root_finder(path))

        local file_parents = file_path:parents()
        local root_parents = root_path:parents()

        local relative_diff = #file_parents - #root_parents
        for index, dir in ipairs(file_parents) do
            if index > relative_diff then
                break
            end

            local astyle_path = Path:new { dir, "astyle.cfg" }
            if astyle_path:exists() then
                cached_configs[path] = astyle_path:absolute()
                break
            end

            astyle_path = Path:new { dir, ".astyle.cfg" }
            if astyle_path:exists() then
                cached_configs[path] = astyle_path:absolute()
                break
            end
        end
    end

    return cached_configs[path]
end

local astyle = {}

astyle.format = function(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    local filepath = Path:new(vim.api.nvim_buf_get_name(bufnr)):absolute()
    local astyle_config = astyle_finder(filepath)

    if not astyle_config then
        return
    end

    -- astyle: ignore
    --
    local args = {
        string.format("--options=%s", astyle_config),
        string.format("--stdin=%s", vim.api.nvim_buf_get_name(0)),
    }

    local j = Job:new {
        command = "astyle",
        args = args,
        writer = vim.api.nvim_buf_get_lines(0, 0, -1, false),
    }

    local output = j:sync()

    if j.code ~= 0 then
        -- Schedule this so that it doesn't do dumb stuff like printing two things.
        vim.schedule(function()
            print "[astyle] Failed to process due to errors"
        end)

        return
    else
        vim.schedule(function()
            print "[astyle] formatted"
        end)
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, output)
end

return astyle
