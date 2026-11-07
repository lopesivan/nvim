-- multcursor.lua

-- alt_Gr-h
vim.keymap.set({ "n", "i" }, "ħ", function()
  local mc_ns = vim.api.nvim_create_namespace("nvim.multicursor")
  vim.api.nvim_buf_clear_namespace(0, mc_ns, 0, -1)

  -- Se estiver no modo de inserção, volta para o modo Normal
  if vim.api.nvim_get_mode().mode == "i" then
    vim.cmd("stopinsert")
  end
end, { desc = "Limpar múltiplos cursores via API" })
