    nvim --cmd "let g:disable_python = 1"

Ler o Argumento no init.lua:
No seu init.lua, verifique se a variável global foi definida:

```{lua}
local python_disabled = vim.g.disable_python == 1

return {
  -- Outras configurações
  pde = {
    -- Outras linguagens
    python = not python_disabled,
    -- Resto das linguagens
  },
}
```
