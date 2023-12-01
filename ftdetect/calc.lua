vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- group = group,
pattern  = { "*.calc" },
callback = function()
   vim.bo.filetype = "calc"
end,
})
