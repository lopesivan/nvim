local fzf = require("fzf")
local themes = require('telescope.themes')

local loop = vim.loop
local api = vim.api

local function _new_file_yml()
  handle = vim.loop.spawn(
  'iprj', {
    args = { 'new', 'file', 'yml' }
  },

  function()
    print('NEW FILE YML')
    handle:close()
  end
  )
end

  --
  -- lua require'libuv.iprj'.new_file_yml()
  -- lua require'libuv.iprj'.new_c()
  -- lua require'libuv.iprj'.new_hw()



coroutine.wrap(function()
  local result = fzf.fzf({"New YML file", "choice 2"}, "--ansi")
  -- result is a list of lines that fzf returns, if the user has chosen
  if result then
    if result[1] == "New YML file" then
	  _new_file_yml()
	end
  end
end)()



