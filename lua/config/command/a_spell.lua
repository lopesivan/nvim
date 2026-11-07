vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("pde_spellcheck", { clear = true }),
  pattern = { "*.txt", "*.md", "*.tex" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "pt"
  end,
  desc = "Enable Portuguese spell checking for prose files",
})
