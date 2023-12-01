-- Função para definir todas as linguagens para false
local function set_all_languages_false(mytable)
  for lang, _ in pairs(mytable) do
    mytable[lang] = false
  end
end
-- Função para definir todas as linguagens para true
local function set_all_languages_true(mytable)
  for lang, _ in pairs(mytable) do
    mytable[lang] = true
  end
end

local pde = {
  cmp = true,
  typescript = true,
  lua = true,
  json = true,
  sh = true,
  yaml = true,
  xml = true,
  octave = true,
  html = true,
  julia = true,
  docker = true,
}

local languages = {
  python = true,
  cpp = false,
  go = false,
  ruby = false,
  csharp = false,
  java = false,
  kotlin = false,
  flutter = false,
  rust = false,
}

set_all_languages_true(languages)
-- set_all_languages_false(languages)

-- Encontrar qual linguagem está definida como true e desativar as outras
-- for lang, value in pairs(languages) do
--   if value then
--     set_all_languages_false(languages)
--     languages[lang] = true
--     break -- Encerra o loop após encontrar a primeira linguagem definida como true
--   end
-- end

-- Mesclando a tabela 'languages' na tabela 'pde'
for k, v in pairs(languages) do
  pde[k] = v
end

return {
  snip = {
    luasnip = true,
    ultisnips = false,
  },
  pde = pde,
}
