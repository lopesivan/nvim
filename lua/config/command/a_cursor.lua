vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  group = vim.api.nvim_create_augroup("pde_cursorline", { clear = true }),
  callback = function()
    vim.opt_local.cursorline = true
  end,
  desc = "Show cursorline in the active window",
})

vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  group = vim.api.nvim_create_augroup(
    "pde_cursorline_hide",
    { clear = true }
  ),
  callback = function()
    vim.opt_local.cursorline = false
  end,
  desc = "Hide cursorline while inserting or leaving a window",
})
