vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- group = group,
pattern  = { "*.avi", "*.mp4", "*.mkv", "*.mov", "*.mpg", "*.webm" },
callback = function()
   vim.bo.filetype = "video"
end,
})
