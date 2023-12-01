vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- group = group,
pattern  = { "*.mail", "*.email" },
callback = function()
   vim.bo.filetype = "mail"
end,
})
