local make = require("my.neovim_dev").make

local file_exists = require("yabs.conditions").file_exists

local function run_make(args)
  local cmd = #args > 0 and ("make " .. table.concat(args, " ")) or "make"
  vim.notify(cmd, vim.log.levels.INFO, { title = "make" })
  vim.defer_fn(function()
    make(args)
  end, 1000)
end
-- local function run_make(args)
--   vim.notify(
--     "make " .. table.concat(args, " "),
--     vim.log.levels.INFO,
--     { title = "make" }
--   )
--   vim.defer_fn(function()
--     make(args)
--   end, 1000) -- ms
-- end

return {
  make = {
    command = function()
      run_make({})
    end,
    opts = { open_on_run = "always" },
    type = "lua",
    condition = file_exists("Makefile"),
  },
  ["make run"] = {
    command = function()
      run_make({ "run" })
    end,
    opts = { open_on_run = "always" },
    condition = file_exists("Makefile"),
    type = "lua",
  },
  ["make test"] = {
    command = function()
      run_make({ "test" })
    end,
    opts = { open_on_run = "always" },
    condition = file_exists("Makefile"),
    type = "lua",
  },
  ["make clean"] = {
    command = function()
      run_make({ "clean" })
    end,
    opts = { open_on_run = "always" },
    condition = file_exists("Makefile"),
    type = "lua",
  },
  ["make install"] = {
    command = function()
      run_make({ "install" })
    end,
    opts = { open_on_run = "always" },
    condition = file_exists("Makefile"),
    type = "lua",
  },
  ["make uninstall"] = {
    command = function()
      run_make({ "uninstall" })
    end,
    opts = { open_on_run = "always" },
    condition = file_exists("Makefile"),
    type = "lua",
  },
}
