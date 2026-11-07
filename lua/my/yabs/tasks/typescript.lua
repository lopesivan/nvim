local app = require("my.neovim_dev").app
local file_exists = require("yabs.conditions").file_exists

local function ts_project()
  return file_exists("package.json")() and file_exists("tsconfig.json")()
end

local function run_cmd(program, args)
  vim.notify(
    program .. " " .. table.concat(args, " "),
    vim.log.levels.INFO,
    { title = program }
  )
  vim.defer_fn(function()
    app(program, args)
  end, 1000) -- ms
end

return {
  ["npx tsc"] = {
    command = function()
      run_cmd("npx", { "tsc" })
    end,
    condition = ts_project,
    type = "lua",
  },
  ["npm test"] = {
    command = function()
      run_cmd("npm", { "test" })
    end,
    condition = ts_project,
    type = "lua",
  },
}
