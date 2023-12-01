-- in ~/.config/nvim/lua/iprj.lua
local M = {}
local loop = vim.loop
local api = vim.api

function M.new_file_yml()

  handle = vim.loop.spawn(
  'iprj', {
    args = {
      'new',
      'file',
      'yml'
    }
  },

  function()
    print('NEW FILE YML')
    handle:close()
  end
  )
end

function M.new_c()

  local choices = {"yml", "cmake", "ccls", "json", "save"}

  require"contextmenu".open( choices,
  {
      callback = function(chosen)
          handle = vim.loop.spawn(
          'iprj', {
            args = {
              'new',
              'c',
              choices[chosen]
            }
          },
          function()
            print('NEW C ' .. choices[chosen])
            handle:close()
          end
          )
      end
  }
  )
end

function M.new_hw()

  local choices = {"yml", "save"}

  require"contextmenu".open( choices,
  {
      callback = function(chosen)
          handle = vim.loop.spawn(
          'iprj', {
            args = {
              'new',
              'hw',
              choices[chosen]
            }
          },
          function()
            print('NEW Hello World ' .. choices[chosen])
            handle:close()
          end
          )
      end
  }
  )
end

function M.new_cpp()

  local choices = {"yml", "save"}

  require"contextmenu".open( choices,
  {
      callback = function(chosen)
          handle = vim.loop.spawn(
          'iprj', {
            args = {
              'new',
              'cpp',
              choices[chosen]
            }
          },
          function()
            print('NEW CPP ' .. choices[chosen])
            handle:close()
          end
          )
      end
  }
  )
end


function M.iprj()

  local choices = {"hw", "c", "cpp"}

  require"contextmenu".open( choices,
  {
      callback = function(chosen)
        -- if choices[chosen] == "hw" then
          M.new_hw()
        -- end
      end
  }
  )
end

------------------------------------------------------------------------------

return M

  --
  -- lua require'libuv.iprj'.new_file_yml()
  -- lua require'libuv.iprj'.new_c()
  -- lua require'libuv.iprj'.new_hw()
