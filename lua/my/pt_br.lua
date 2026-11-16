-- pt_br.lua

local spell_dir = vim.fn.stdpath("config") .. "/spell/"

vim.opt.spellfile = spell_dir .. "pt.utf-8.add"

vim.keymap.set("n", "<leader>sp", function()
  vim.opt.spell = not vim.opt.spell:get()

  if vim.opt.spell:get() then
    vim.opt.spelllang = "pt"
    vim.notify("Spell PT-BR: ON", vim.log.levels.INFO)
  else
    vim.notify("Spell PT-BR: OFF", vim.log.levels.INFO)
  end
end, { desc = "Toggle spell check PT-BR" })

-- <leader>sp   " liga
-- <leader>sp   " desliga
-- ]s           " próximo erro
-- [s           " erro anterior
-- z=           " sugestões
-- zg           " adiciona palavra ao dicionário
