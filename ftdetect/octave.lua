vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  -- group = group,
  pattern = { "*.oc" },
  callback = function()
    vim.bo.filetype = "octave"
    vim.bo.syntax = "matlab"
  end,
})
