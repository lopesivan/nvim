vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- group = group,
pattern  = { "*.md" ,"*.wiki" },
callback = function()
   vim.bo.filetype = "markdown"
end,
})
