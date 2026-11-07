local app = require("my.neovim_dev").app
local file_exists = require("yabs.conditions").file_exists

local function run_gradlew(args)
  vim.notify(
    "./gradlew " .. table.concat(args, " "),
    vim.log.levels.INFO,
    { title = "gradlew" }
  )
  vim.defer_fn(function()
    app("./gradlew", args)
  end, 1000) -- ms
end

return {
  ["./gradlew run"] = {
    command = function()
      run_gradlew({ "run" })
    end,
    condition = file_exists("gradlew"),
    type = "lua",
  },
  ["./gradlew jar"] = {
    command = function()
      run_gradlew({ "jar" })
    end,
    condition = file_exists("gradlew"),
    type = "lua",
  },
  ["./gradlew clean"] = {
    command = function()
      run_gradlew({ "clean" })
    end,
    condition = file_exists("gradlew"),
    type = "lua",
  },
  ["./gradlew build"] = {
    command = function()
      run_gradlew({ "build" })
    end,
    condition = file_exists("gradlew"),
    type = "lua",
  },
  ["./gradlew --stop"] = {
    command = function()
      run_gradlew({ "--stop" })
    end,
    condition = file_exists("gradlew"),
    type = "lua",
  },
}
