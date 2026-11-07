local util = require("my.yabs.util")
local load_from_env = util.load_commands_from_env

local file_exists = require("yabs.conditions").file_exists

return {
  ["env.local"] = {
    command = function()
      load_from_env("cmd_build", "local")
    end,
    condition = file_exists(".env"),
    type = "lua",
    desc = "executa LOCAL={cmd1, cmd2,..} presente em .env",
  },

  ["env.test"] = {
    command = function()
      load_from_env("cmd", "test")
    end,
    condition = file_exists(".env"),
    type = "lua",
    desc = "executa TEST={cmd1, cmd2,..} presente em .env",
  },

  ["env.git"] = {
    command = function()
      load_from_env("cmd", "git")
    end,
    condition = file_exists(".env"),
    type = "lua",
    desc = "executa GIT={cmd1, cmd2,..} presente em .env",
  },
}
