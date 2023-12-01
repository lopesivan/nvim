return {
  name = "busted",
  builder = function()
    local file = vim.fn.expand "%:p"
    return {
      cmd = { "busted" },
      args = { file },
      cwd = vim.fn.getcwd(),
      components = { { "on_complete_notify" }, "default" },
    }
  end,
  condition = {
    filetype = { "lua" },
  },
}
