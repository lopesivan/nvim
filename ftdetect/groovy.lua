vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- group = group,
pattern  = { "*.groovy" ,"*.gvy" ,"*.gy" ,"*.gsh" },
callback = function()
   vim.bo.filetype = "groovy"
end,
})
