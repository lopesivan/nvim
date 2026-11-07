vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("pde_highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
  desc = "Highlight yanked text",
})
