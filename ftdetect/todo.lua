vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- group = group,
pattern  = { "*.todo" },
callback = function()
   vim.bo.filetype = "todo"
end,
})
