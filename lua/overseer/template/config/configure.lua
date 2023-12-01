return {
  name = "[overseer] ./configure",
  builder = function()
    local script = string.format("./%s", "configure")
    return {
      cmd = { script },
      components = { { "on_output_quickfix", open = true }, "default" },
    }
  end,
  condition = {
    filetype = { "c" },
  },
}
