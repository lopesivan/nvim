vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- group = group,
pattern  = { "*.gitignore" },
callback = function()
   vim.bo.filetype = "gitignore"
end,
})

