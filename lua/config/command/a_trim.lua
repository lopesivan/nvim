vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup(
    "pde_trim_trailing_whitespace",
    { clear = true }
  ),
  callback = function(event)
    if vim.bo[event.buf].binary or not vim.bo[event.buf].modifiable then
      return
    end

    local view = vim.fn.winsaveview()
    vim.cmd([[keepjumps keeppatterns silent! %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
  desc = "Remove trailing whitespace before saving",
})
