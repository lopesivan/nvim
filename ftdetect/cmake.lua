vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- group = group,
pattern  = { "CMakeLists.txt" },
callback = function()
   vim.bo.filetype = "cmake"
end,
})
