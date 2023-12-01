-- local group = vim.api.nvim_create_augroup("audio", {clear = true})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  -- group = group,
  pattern = { "*.mp3", "*.flac", "*.wav", "*.ogg" },
  callback = function()
    vim.bo.filetype = "audio"
  end,
})
