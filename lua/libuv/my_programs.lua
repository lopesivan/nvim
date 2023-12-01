local M = {}

local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local sorters = require "telescope.sorters"
local dropdown = require("telescope.themes").get_dropdown()

local function enter(prompt_bufnr)
  local selected = action_state.get_selected_entry()
  local cmd = string.format("lua require('libuv.%s').command_toggle()", selected[1])
  actions.close(prompt_bufnr)
  vim.cmd(cmd)
end

local terminal_program_table = {
  "bc",
  "cling",
  "julia",
  "lua",
  "maple",
  "ngspice",
  "nu",
  "pythagoras",
  "python",
  "ruby",
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
