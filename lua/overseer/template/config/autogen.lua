return {
  name = "[overseer] ./autogen.sh",
  builder = function()
    local script = string.format("./%s", "autogen.sh")
    return {
      cmd = { script },
      components = { { "on_output_quickfix", open = true }, "default" },
    }
  end,
  condition = {
    filetype = { "c" },
  },
}
