vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("pde_last_location", { clear = true }),
  callback = function(event)
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(event.buf)

    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Restore the cursor to the last known position",
})
