return {
  name = "[overseer] ./gradlew",
  builder = function()
    local script = string.format("./%s", "gradlew")
    return {
      cmd = { script },
      -- components = { { "on_output_quickfix", open = true }, "default" },
    }
  end,
  condition = {
    filetype = { "kotlin" },
  },
}
