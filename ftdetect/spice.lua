vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- group = group,
pattern  = { "*.cir" ,"*.sp" },
callback = function()
   vim.bo.filetype = "spice"
end,
})
