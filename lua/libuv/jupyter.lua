local M = {}

local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local sorters = require "telescope.sorters"
local dropdown = require("telescope.themes").get_dropdown()
local Terminal = require("toggleterm.terminal").Terminal

local function enter(prompt_bufnr)
    local selected = action_state.get_selected_entry()
    local cmd = string.format("jupyter console --kernel %s", selected[1])
    local command_client = Terminal:new {
        cmd = cmd,
        dir = string.format("%s", vim.fn.getcwd()),
        hidden = true,
        env = { ["PYENV_VERSION"] = "jupyter" },
        direction = "float",
        float_opts = {
            border = "double",
        },
    }

    actions.close(prompt_bufnr)
    command_client:toggle()
end

local terminal_program_table = {
    "bash",
    "cling-cpp11",
    "cling-cpp14",
    "cling-cpp17",
    "cling-cpp1z",
    "java",
    "jslab",
    "julia-1.6",
    "julia_env",
    "octave",
    "pyspace",
    "pyspice",
    "python2",
    "python3",
    "tslab",
    "wolframlanguage12",
    "wx",
}

local opts = {
    finder = finders.new_table(terminal_program_table),
    sorter = sorters.get_generic_fuzzy_sorter {},
    attach_mappings = function(prompt_bufnr, map)
        map("i", "<CR>", enter)
        return true
    end,
}

local terminal_programs = pickers.new(dropdown, opts)

function M.startup()
    terminal_programs:find()
end

return M
