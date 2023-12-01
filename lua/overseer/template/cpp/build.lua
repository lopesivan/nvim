return {
  name = "[overseer] build",
  builder = function()
    -- Full path to current file (see :help expand())
    local file = vim.fn.expand "%:p"
    local outfile = string.format("./%s", vim.fn.expand "%:r")
    return {
      cmd = { "g++" },
      args = { file, "-o", outfile },
      -- components = { { "on_output_quickfix", open = true }, "default" },
    }
  end,
  desc = "build with g++",
  condition = {
    filetype = { "cpp" },
  },
}
