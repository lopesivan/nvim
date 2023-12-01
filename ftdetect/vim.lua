vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- group = group,
pattern  = { "*.vim" ,"*.local" },
callback = function()
   vim.bo.filetype = "vim"
end,
})
