vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- group = group,
pattern  = { ".ccls" },
callback = function()
   vim.bo.filetype = "ccls"
end,
})
