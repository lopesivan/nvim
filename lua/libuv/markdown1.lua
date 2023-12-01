-- in ~/.config/nvim/lua/libuv/markdown.lua

local M = {}
local utils = require('telescope.utils')
local api = vim.api

local function table_to_string(tbl)
    local result = "{"
    for k, v in pairs(tbl) do
        -- Check the key type (ignore any numerical keys - assume its an array)
        if type(k) == "string" then
            result = result.."[\""..k.."\"]".."="
        end

        -- Check the value type
        if type(v) == "table" then
            result = result..table_to_string(v)
        elseif type(v) == "boolean" then
            result = result..tostring(v)
        else
            result = result.."\""..v.."\""
        end
        result = result..","
    end
    -- Remove leading commas from the result
    if result ~= "" then
        result = result:sub(1, result:len()-1)
    end
    return result.."}"
end

function M.convertFile(filetype)
  local shortname = vim.fn.expand('%:t:r')
  local fullname = api.nvim_buf_get_name(0)
  local cmd = {'pandoc'}

  if filetype == 'html' then
	cmd = {
	  'pandoc',
	  fullname,
	  '--to=html5',
	  '-o', string.format('%s.html', shortname),
	  '-s',
	  '--highlight-style', 'tango',
	  '-c', '--css=pandoc.css'}
  end

  local stdout, ret, stderr = utils.get_os_command_output(cmd)

  if ret == 0 then
	print(vim.inspect.inspect(cmd))
	-- print(table_to_string(cmd))
	if #stdout > 0 then
	  for _, v in ipairs(stdout) do
		print(v)
	  end
	end
	print('Conversion successful!')
  end

  if #stderr > 0 then
	for _, v in ipairs(stderr) do
	  print(v)
	end
  end

end


return M

