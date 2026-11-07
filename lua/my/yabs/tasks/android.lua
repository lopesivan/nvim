local util = require("my.yabs.util")
local capture = util.capture_command_output
local app = require("my.neovim_dev").app
local file_exists = require("yabs.conditions").file_exists
local has_ant_android_files = file_exists("build.xml")
  and file_exists("AndroidManifest.xml")

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
  ["ant debug"] = {
    command = function()
      run_cmd("ant", { "debug" })
    end,
    condition = file_exists("build.xml"),
    type = "lua",
  },
  ["ant release"] = {
    command = function()
      run_cmd("ant", { "release" })
    end,
    condition = file_exists("build.xml"),
    type = "lua",
  },
  ["adb run"] = {
    command = function()
      local pkg = capture(
        "xmlstarlet select -T -t -v '//manifest/@package' -n AndroidManifest.xml"
      )
      local act = capture(
        'xmlstarlet select -T -t -v "//manifest/application/activity/@android:name" -n AndroidManifest.xml'
      )
      run_cmd(
        "adb",
        { "shell", "am", "start", "-n", ("%s/%s"):format(pkg, act) }
      )
    end,
    condition = has_ant_android_files,
    type = "lua",
  },
  ["adb uninstall"] = {
    command = function()
      local pkg = capture(
        "xmlstarlet select -T -t -v '//manifest/@package' -n AndroidManifest.xml"
      )
      run_cmd("adb", { "uninstall", ("%s"):format(pkg) })
    end,
    condition = has_ant_android_files,
    type = "lua",
  },
  ["ant installd"] = {
    command = function()
      run_cmd("ant", { "installd" })
    end,
    condition = has_ant_android_files,
    type = "lua",
  },
  ["ant installr"] = {
    command = function()
      run_cmd("ant", { "installr" })
    end,
    condition = has_ant_android_files,
    type = "lua",
  },
  ["adb shell input keyevent KEYCODE_BACK"] = {
    command = function()
      run_cmd("adb", { "shell", "input", "keyevent", "KEYCODE_BACK" })
    end,
    condition = has_ant_android_files,
    type = "lua",
  },
  ["adb shell input keyevent KEYCODE_HOME"] = {
    command = function()
      run_cmd("adb", { "shell", "input", "keyevent", "KEYCODE_HOME" })
    end,
    condition = has_ant_android_files,
    type = "lua",
  },
}
