if vim.fn.executable "astyle" == 0 then
  return
end

local group = vim.api.nvim_create_augroup("AstyleAuto", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = group,
  pattern = { "*.c", "*.h", "*.cpp" },
  callback = function()
    require("config.astyle").format()
  end,
})
