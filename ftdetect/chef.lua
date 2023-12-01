vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- group = group,
pattern  = { "*.chef" },
callback = function()
   vim.bo.filetype = "chef"
   vim.bo.syntax="ruby"
end,
})
