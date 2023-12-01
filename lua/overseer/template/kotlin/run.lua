return {
  name = "[overseer] ./gradlew run",
  builder = function()
    local script = string.format("./%s", "gradlew")
    return {
      cmd = { script },
      args = { "run" },
      -- components = { { "on_output_quickfix", open = true }, "default" },
    }
  end,
  condition = {
    filetype = { "kotlin" },
  },
}
