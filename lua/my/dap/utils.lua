-- lua/base/dap/utils.lua
local M = {}

local uv = vim.uv or vim.loop

local function file_exists(path)
    return path and uv.fs_stat(path) ~= nil
end

local function is_executable(path)
    return file_exists(path) and vim.fn.executable(path) == 1
end

function M.workspace_root()
    local current = vim.api.nvim_buf_get_name(0)
    local root_markers = {
        ".git",
        "compile_commands.json",
        "CMakeLists.txt",
        "Cargo.toml",
        "Makefile",
    }

    local root = vim.fs.dirname(vim.fs.find(root_markers, {
        path = current ~= "" and current or vim.fn.getcwd(),
        upward = true,
    })[1] or "")

    return root ~= "" and root or vim.fn.getcwd()
end

function M.pick_binary()
    local cwd = M.workspace_root()
    local current = vim.api.nvim_buf_get_name(0)
    local stem = vim.fn.fnamemodify(current, ":t:r")
    local candidates = {
        cwd .. "/" .. stem,
        cwd .. "/build/" .. stem,
        cwd .. "/bin/" .. stem,
        cwd .. "/build/debug/" .. stem,
        cwd .. "/build/Debug/" .. stem,
        cwd .. "/out/" .. stem,
    }

    for _, candidate in ipairs(candidates) do
        if is_executable(candidate) then
            vim.notify("DAP launching " .. candidate, vim.log.levels.INFO)
            return candidate
        end
    end

    local picked = vim.fn.input("Path to executable: ", cwd .. "/", "file")
    if picked == "" then
        vim.notify("DAP launch cancelled: no executable selected", vim.log.levels.WARN)
        return nil
    end
    if not is_executable(picked) then
        vim.notify("DAP launch aborted: not executable: " .. picked, vim.log.levels.ERROR)
        return nil
    end
    return picked
end

function M.split_args(input)
    local args = {}
    for arg in string.gmatch(input, "%S+") do
        table.insert(args, arg)
    end
    return args
end

function M.prompt_args()
    return M.split_args(vim.fn.input("Program arguments: "))
end

return M
