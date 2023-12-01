local actions = require('telescope.actions')
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local pickers = require('telescope.pickers')
local previewers = require('telescope.previewers')
local utils = require('telescope.utils')
local conf = require('telescope.config').values

local M = {}
local loop = vim.loop
local api = vim.api

-- branches = require('telescope.builtin.git').branches
local branchesss = function(opts)
  -- Does this command in lua (hopefully):
  -- 'git branch --all | grep -v HEAD | sed "s/.* //;s#remotes/[^/]*/##" | sort -u'
  local output = vim.split(utils.get_os_command_output('git branch --all'), '\n')

  local tmp_results = {}
  for _, v in ipairs(output) do
    if not string.match(v, 'HEAD') and v ~= '' then
      v = string.gsub(v, '.* ', '')
      v = string.gsub(v, '^remotes/.*/', '')
      tmp_results[v] = true
    end
  end

  local results = {}
  for k, _ in pairs(tmp_results) do
    table.insert(results, k)
  end

  pickers.new(opts, {
    prompt_title = 'Git Branches',
    finder = finders.new_table {
      results = results,
      entry_maker = function(entry)
        return {
          value = entry,
          ordinal = entry,
          display = entry,
        }
      end
    },
    previewer = previewers.git_branch_log.new(opts),
    sorter = conf.file_sorter(opts),
    attach_mappings = function()
      actions.goto_file_selection_edit:replace(actions.git_checkout)
      return true
    end
  }):find()
end

function M.executeTest()
  branchesss()
  -- require 'pl.pretty'.dump(results)
end
return M


