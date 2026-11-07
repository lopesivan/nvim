-- ~/.config/nvim/lua/config/yabs/init.lua
local M = {}

-- Carrega mopdulo se existir
local function require_module(name)
  local ok, mod = pcall(require, name)
  if not ok then
    vim.notify("module not found: " .. name, vim.log.levels.ERROR)
    return nil
  end
  return mod
end

-- funcao que carrega o módulo quando chamada.
function M.setup()
  local yabs = require_module("yabs")
  local dotenv = require_module("dotenv") -- opcional, mas pedimos cedo p/ avisar
  if not yabs then
    return
  end

  local languages = require("my.yabs.languages")
  local tasks = require("my.yabs.tasks")

  local opts = {
    output_types = {
      quickfix = { open_on_run = "always" },
    },
  }

  yabs:setup({
    languages = languages,
    tasks = tasks,
    opts = opts,
  })
end

return M
