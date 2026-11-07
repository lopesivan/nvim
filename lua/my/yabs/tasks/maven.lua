local app = require("my.neovim_dev").app
local file_exists = require("yabs.conditions").file_exists

local function run_mvn(args)
  vim.notify(
    "mvn " .. table.concat(args, " "),
    vim.log.levels.INFO,
    { title = "mvn" }
  )
  vim.defer_fn(function()
    app("mvn", args)
  end, 1000) -- ms
end

return {
  ["mvn package -Dorg.slf4j.simpleLogger.defaultLogLevel=debug"] = {
    command = function()
      run_mvn({ "package", "-Dorg.slf4j.simpleLogger.defaultLogLevel=debug" })
    end,
    condition = file_exists("pom.xml"),
    type = "lua",
  },
  ["mvn compile"] = {
    command = function()
      run_mvn({ "compile" })
    end,
    condition = file_exists("pom.xml"),
    type = "lua",
  },
  ["mvn clean"] = {
    command = function()
      run_mvn({ "clean" })
    end,
    condition = file_exists("pom.xml"),
    type = "lua",
  },
  ["mvn exec:java"] = {
    command = function()
      run_mvn({ "exec:java" })
    end,
    condition = file_exists("pom.xml"),
    type = "lua",
  },
  ["mvn jar:jar"] = {
    command = function()
      run_mvn({ "jar:jar" })
    end,
    condition = file_exists("pom.xml"),
    type = "lua",
  },
}
