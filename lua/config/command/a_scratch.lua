vim.api.nvim_create_user_command("Scratch", function()
  vim.cmd("belowright 10new")
  local buf = vim.api.nvim_get_current_buf()

  for option, value in pairs({
    filetype = "scratch",
    buftype = "nofile",
    bufhidden = "wipe",
    swapfile = false,
    modifiable = true,
  }) do
    vim.api.nvim_set_option_value(option, value, { buf = buf })
  end
end, { desc = "Open a scratch buffer" })
