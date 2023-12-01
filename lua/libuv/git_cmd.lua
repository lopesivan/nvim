local M = {}

local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local sorters = require "telescope.sorters"
local dropdown = require "telescope.themes".get_dropdown()

local function enter(prompt_bufnr)
    local selected = action_state.get_selected_entry()
    -- local cmd      = string.format("%s", selected[1])
    actions.close(prompt_bufnr)

    local num = tonumber(string.match(selected[1], "^(%d+):"))
    local valor = num

    local cases = {
        [1] = function()
            print("git branch --show-current")
            require('config.nvim_dev').app("git", { 'branch', '--show-current' })
        end,
        [2] = function()
            local branch = vim.fn.trim(vim.fn.system("git branch --show-current"))
            print(branch)
            print("git push --set-upstream origin", branch)
            require('config.nvim_dev').app("git", { 'push', '--set-upstream', 'origin', branch })
        end,
        [3] = function()
            require('config.nvim_dev').app("git", { 'push' })
        end,
        [4] = function()
            require('config.nvim_dev').app("git", { 'cd' })
        end,
        [5] = function()
            require('config.nvim_dev').app("git", { 'ls' })
        end,
        [6] = function()
            local current_file = vim.api.nvim_buf_get_name(0)
            print("Nome do arquivo corrente: " .. current_file)
            require('config.nvim_dev').app("git", { 'add', '-f', current_file })
        end,
    }

    if cases[valor] then
        -- Verifica se existe um caso correspondente na tabela
        cases[valor]()
    else
        -- Caso nenhum caso correspondente seja encontrado
        print("out of value")
        require("notify")("Valor não encontrado.", "Error")
    end

    -- ll = "git branch --show-current"
    -- require('config.nvim_dev').app(cmd, { '' })
end

local git_command_table = {
    "1: [git] show current branch name",
    "2: [git] push current branch",
    "3: [git] push",
    "4: [git] cd",
    "5: [git] ls",
    "6: [git] add -f current file",
    "7: Push to origin/main branch for submodule?",
}

local opts = {
    finder = finders.new_table(git_command_table),
    sorter = sorters.get_generic_fuzzy_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
        map("i", "<CR>", enter)
        -- map("i", "<Down>", next_git_command)
        -- map("i", "<Up>", prev_git_command)
        return true
    end
}

local git_commands = pickers.new(dropdown, opts)

function M.startup()
    git_commands:find()
end

return M
