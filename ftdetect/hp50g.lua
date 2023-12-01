vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- group = group,
pattern  = { "*.hp50" ,"*.hp50g" },
callback = function()
   vim.bo.filetype = "hp50g"
end,
})
