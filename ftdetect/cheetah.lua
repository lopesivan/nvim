vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- group = group,
pattern  = { "*.cheetah", "*.tmpl" },
callback = function()
   vim.bo.filetype = "cheetah"
end,
})
