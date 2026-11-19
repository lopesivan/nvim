return {
  {
    "mason-org/mason.nvim",
    lazy = true,
    config = function()
      require("mason").setup({
        registries = {
          "github:Crashdummyy/mason-registry",
          "github:mason-org/mason-registry",
        },
        ui = {
          icons = {
            package_installed = "💊",
            package_pending = "💚",
            package_uninstalled = "💔",
          },
        },
      })
    end,
  },

  -- Servidores LSP
  {
    "mason-org/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "bashls",
          "clangd",
          "glsl_analyzer",
          "jdtls",
          "jsonls",
          "lua_ls",
          "marksman",
          "pyright",
          "ruff",
        },
        automatic_enable = false,
      })
    end,
  },

  -- Formatadores, linters e depuradores
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    cmd = {
      "MasonToolsInstall",
      "MasonToolsUpdate",
      "MasonToolsClean",
    },
    dependencies = {
      "mason-org/mason.nvim",
    },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Python
          "autopep8",
          "black",

          -- Java
          "google-java-format",

          -- JavaScript / JSON / HTML / CSS
          "prettier",

          -- Shell
          "shfmt",

          -- XML
          "xmlformatter",

          -- Debuggers
          "bash-debug-adapter",
          "codelldb",

          -- C# (registro personalizado)
          "roslyn-nightly",
        },
        auto_update = false,
        run_on_start = true,
        start_delay = 1000,
      })
    end,
  },
}

--[[
Para listar tudo que foi instalado pelo **Mason** no Neovim 0.13, você tem algumas opções.

### **1. Pela interface do Mason**

Dentro do Neovim:

```
:Mason
```

A interface mostra os pacotes instalados, disponíveis e suas versões.

### **2. Listar os pacotes instalados via Lua**

Execute no Neovim:

```
:lua print(vim.inspect(require("mason-registry").get_installed_package_names()))
```

Para uma lista organizada, um pacote por linha:

```
:lua for _, name in ipairs(require("mason-registry").get_installed_package_names()) do print(name) end
```

### **3. Pelo terminal Linux**

Como você utiliza Ubuntu, pode executar:

```
ls -1 ~/.local/share/nvim/mason/packages/
```

**Atenção:** se você utiliza `NVIM_APPNAME=nvim-pde`, o caminho provavelmente será:

```
ls -1 ~/.local/share/nvim-pde/mason/packages/
```

### **4. Mostrar nome e versão de cada pacote**

Dentro do Neovim:

```
local registry = require("mason-registry")

for _, name in ipairs(registry.get_installed_package_names()) do
  local pkg = registry.get_package(name)
  local version = pkg:get_installed_version() or "desconhecida"

  print(string.format("%-30s %s", name, version))
end
```

### **5. Verificar os executáveis instalados**

No terminal:

```
ls -l ~/.local/share/nvim-pde/mason/bin/
```

Esse diretório contém os executáveis disponibilizados pelo Mason, como servidores LSP, formatadores, linters e ferramentas DAP.

**Minha sugestão:** utilize `:Mason` para gerenciar os pacotes e `mason-registry` para obter uma lista programaticamente. Lembre-se de que **um pacote instalado não significa necessariamente que ele esteja configurado ou ativo no buffer atual**.

]]
