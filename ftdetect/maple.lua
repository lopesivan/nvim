vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- group = group,
pattern  = { "*.mm" ,"*.maple" ,"*.mv" ,"*.mpl" },
callback = function()
   vim.bo.filetype = "maple"
end,
})
