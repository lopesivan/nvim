return {
  name = "[overseer] ./gradlew clean",
  builder = function()
    local script = string.format("./%s", "gradlew")
    return {
      cmd = { script },
      args = { "clean" },
      -- components = { { "on_output_quickfix", open = true }, "default" },
    }
  end,
  condition = {
    filetype = { "kotlin" },
  },
}
