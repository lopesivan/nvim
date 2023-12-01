return {
  name = "[overseer] run",
  builder = function()
    -- Full path to current file (see :help expand())
    local cmd = string.format("./%s", vim.fn.expand "%:r")
    local outfile = string.format("./%s.out", vim.fn.expand "%:r")
    return {
      cmd = { cmd },
      -- components = { { "on_output_write_file", filename = outfile }, "default" },
    }
  end,
  condition = {
    filetype = { "c" },
  },
}
