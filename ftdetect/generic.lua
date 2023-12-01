vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- group = group,
pattern  = { "*.generic" },
callback = function()
   vim.bo.filetype = "generic"
end,
})
