local markdown_theme_group =
  vim.api.nvim_create_augroup("MarkdownLightTheme", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = markdown_theme_group,
  pattern = "markdown",
  callback = function(args)
    -- ignora janelas flutuantes (hover, signature help, etc.)
    local win = vim.fn.bufwinid(args.buf)
    if win ~= -1 and vim.api.nvim_win_get_config(win).relative ~= "" then
      return
    end
    -- ignora buffers não-arquivo (nofile/scratch)
    if vim.bo[args.buf].buftype ~= "" then
      return
    end

    require("lazy").load({ plugins = { "solarized.nvim" } })
    vim.opt.background = "light"
    vim.cmd.colorscheme("solarized")
  end,
})
