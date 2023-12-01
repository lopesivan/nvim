vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- group = group,
pattern  = { "*.tex" ,"*.latexc" },
callback = function()
   vim.bo.filetype = "tex"
end,
})
