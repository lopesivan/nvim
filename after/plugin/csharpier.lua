if vim.fn.executable "dotnet-csharpier" == 0 then
  return
end

local group = vim.api.nvim_create_augroup("CsharpierAuto", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = group,
  pattern = { "*.cs" },
  callback = function()
    require("config.csharpier").format()
  end,
})
