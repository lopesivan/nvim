return {
  name = "[overseer] build",
  builder = function()
    -- Full path to current file (see :help expand())
    local file = vim.fn.expand "%:p"
    local outfile = string.format("./%s", vim.fn.expand "%:r")
    return {
      cmd = { "gcc" },
      args = { file, "-o", outfile },
      -- components = { { "on_output_quickfix", open = true }, "default" },
    }
  end,
  condition = {
    filetype = { "c" },
  },
}
