local map = vim.api.nvim_set_keymap

-- wiki functions
local function c(lua_template_fun)
  return string.format("<CMD>lua R('config.template').%s<CR>", lua_template_fun)
end

local function l(leader_map)
  return string.format("<leader>%s", leader_map)
end

map("n", l "hw", c "load()", { noremap = true, desc = "Hello World" })
map("n", l "1", c "yaml()", { noremap = true, desc = "Python Cheetah Yaml template" })
map("n", l "2", "<CMD>Cheetah<CR>", { noremap = true, desc = "Load Cheetah template" })

-- local map = vim.api.nvim_set_keymap
-- local options = { noremap = true }
-- map('n', '<Leader>ipc',"<CMD>lua require'libuv.iprj'.new_c()<CR>",options)
