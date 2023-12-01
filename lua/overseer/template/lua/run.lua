return {
  name = "[overseer] run",
  builder = function()
    local file = vim.fn.expand "%:p"
    return {
      cmd = { "lua" },
      args = { file },
      cwd = vim.fn.getcwd(),
      components = {
        { "on_output_quickfix", set_diagnostics = true, open = false },
        "on_result_diagnostics",
        "default",
      },
    }
  end,
  desc = "run lua file",
  condition = {
    filetype = { "lua" },
  },
}
