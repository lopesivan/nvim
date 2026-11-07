local function parse_env_file(filepath)
    -- Check if file exists
    local file = io.open(filepath, "r")
    if not file then
        return {}
    end

    local env = {}

    -- Read file line by line
    for line in file:lines() do
        -- Skip empty lines and comments
        if line:match "^%s*[^#]" then
            -- Remove leading/trailing whitespace
            line = line:match "^%s*(.-)%s*$"

            -- Remove optional "export" keyword
            line = line:gsub("^export%s+", "")

            -- Find the first equals sign
            local pos = line:find "="

            if pos then
                local key = line:sub(1, pos - 1):match "^%s*(.-)%s*$"
                local value = line:sub(pos + 1):match "^%s*(.-)%s*$"

                -- Remove quotes if they exist
                if value:match '^".*"$' or value:match "^'.*'$" then
                    value = value:sub(2, -2)
                end

                -- Store in environment table
                env[key] = value
            end
        end
    end

    file:close()
    return env
end

return {
    parse = parse_env_file,
    parse_plugin_env = function()
        -- local str = debug.getinfo(2, "S").source:sub(2)
        -- print("Trying to resolve from:", str)
        local cwd = vim.fn.getcwd()
        local root = vim.fs.root(cwd, { ".env" })
        if root then
            return parse_env_file(vim.fs.joinpath(root, ".env"))
        end

        return {}
    end,
    eval = function(file, force)
        local parsed = parse_env_file(file)
        for k, v in pairs(parsed) do
            if force or not vim.env[k] then
                vim.env[k] = v
            end
        end
    end,
}


--[[
No seu código, a função `eval` é responsável por
**carregar as variáveis do `.env` diretamente para o
ambiente do Neovim** (`vim.env`). Ela basicamente faz o que
`export VAR=val` faria em um shell, mas dentro do Neovim.

---

### ✨ O que faz `eval(file, force)`?

Aqui está a definição:

```lua
eval = function(file, force)
  local parsed = parse_env_file(file)
  for k, v in pairs(parsed) do
    if force or not vim.env[k] then
      vim.env[k] = v
    end
  end
end
```

#### 📌 O que ela faz:

* **Lê** as variáveis do arquivo `.env`.
* **Coloca** essas variáveis em `vim.env` (o ambiente do Neovim).
* Só sobrescreve variáveis **se**:

  * `force == true`, ou
  * A variável ainda não existe no ambiente.

---

### ✅ Como usar na prática

#### 1. Suponha que você tenha um `.env` no seu projeto:

```dotenv
API_KEY=abc123
DEBUG=true
```

#### 2. E no seu `init.lua`, ou dentro de um plugin:

```lua
require("config.dotenv").eval(vim.fn.getcwd() .. "/.env", false)

-- Agora você pode acessar:
print(vim.env.API_KEY)  --> abc123
```

#### 3. Se quiser forçar a reavaliação mesmo que
`vim.env.API_KEY` já exista:

```lua
require("config.dotenv").eval(vim.fn.getcwd() .. "/.env", true)
```

---

### 🔁 Diferença entre `parse`, `parse_plugin_env` e `eval`:

| Função               | O que faz                                                       |
| -------------------- | --------------------------------------------------------------- |
| `parse(file)`        | Retorna uma tabela com as variáveis lidas do `.env`             |
| `parse_plugin_env()` | Detecta o `.env` automaticamente (baseado no projeto)           |
| `eval(file, force)`  | Lê o `.env` e preenche `vim.env`, como um `export` programático |

---

### 🧠 Quando usar `eval`

* Você quer que **todas as variáveis fiquem acessíveis
globalmente no Neovim**, por exemplo para:

  * Plugins que leem `vim.env` (como `nvim-lint`, `null-ls`, etc).
  * Comandos personalizados no terminal Neovim.
  * Subprocessos lançados com `vim.fn.jobstart()`.

---

]]
