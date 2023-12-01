vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- group = group,
pattern  = { "*.gdb" },
callback = function()
   vim.bo.filetype = "gdb"
end,
})
