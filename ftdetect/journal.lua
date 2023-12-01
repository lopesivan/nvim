vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- group = group,
pattern  = { "*.j" },
callback = function()
   vim.bo.filetype = "journal"
end,
})
