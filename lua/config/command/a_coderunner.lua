-- -----------------------------------------------------------------------------
-- Atalhos de execução por linguagem
-- -----------------------------------------------------------------------------
local function CodeRunner(bufnr)
  if
    not vim.api.nvim_buf_is_valid(bufnr)
    or not vim.api.nvim_buf_is_loaded(bufnr)
  then
    return
  end

  local ft = vim.bo[bufnr].filetype
  local fname = vim.fs.basename(vim.api.nvim_buf_get_name(bufnr))

  local PKG_CONFIG = 'PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig" '
  local function register_keymaps(mode, keymap, buffer)
    if not keymap or next(keymap) == nil then
      return
    end

    local ok, which_key = pcall(require, "which-key")

    if not ok then
      vim.notify(
        "Não foi possível carregar o which-key",
        vim.log.levels.WARN
      )
      return
    end

    which_key.register({
      c = keymap,
    }, {
      mode = mode,
      silent = true,
      noremap = true,
      buffer = buffer,
      prefix = "<leader>",
      nowait = true,
    })
  end

  local keymaps = {
    python = {
      name = "🐍 Code",

      p = {
        function()
          vim.cmd("split term://python")
          require("config.repl").set_job_id()
        end,
        "🐍 Abrir Python REPL",
      },

      i = {
        function()
          vim.cmd("split term://ipython")
        end,
        "🔬 Abrir IPython REPL",
      },

      r = {
        function()
          vim.cmd("!python %")
        end,
        "▶️ Executar script",
      },
    },

    lua = {
      name = "🌙 Code",

      p = {
        function()
          vim.cmd("split term://luap")
        end,
        "🌙 Abrir Lua REPL",
      },

      l = {
        function()
          vim.cmd("!lua %")
        end,
        "▶️ Executar com lua",
      },
      r = {
        function()
          vim.cmd("luafile %")
        end,
        "▶️ Executar com luafile",
      },
    },

    c = {
      name = "🔧 Code",

      p = {
        function()
          vim.cmd("split term://cling")
        end,
        "💻 Abrir Cling REPL",
      },
      v = {
        function()
          vim.cmd("update")

          local source = vim.api.nvim_buf_get_name(bufnr)
          local executable = vim.fn.fnamemodify(source, ":r")
          local valgrind_options = table.concat({
            "valgrind",
            "--leak-check=full",
            "--show-leak-kinds=all",
            "--track-origins=yes",
            "--errors-for-leak-kinds=all",
            "--error-exitcode=1",
          }, " ")

          local command = string.format(
            "gcc -g -O0 -Wall -Wextra %s -o %s && %s %s",
            vim.fn.shellescape(source),
            vim.fn.shellescape(executable),
            valgrind_options,
            vim.fn.shellescape(executable)
          )

          vim.cmd("split")
          vim.cmd.terminal(command)
        end,
        "🔍 Executar com Valgrind",
      },
    },

    cpp = {
      name = "⚙️ Code",

      p = {
        function()
          vim.cmd("split term://cling -std=c++17")
        end,
        "💻 Abrir Cling C++17",
      },
      v = {
        function()
          vim.cmd("update")

          local source = vim.api.nvim_buf_get_name(bufnr)
          local executable = vim.fn.fnamemodify(source, ":r")

          local valgrind_options = table.concat({
            "valgrind",
            "--leak-check=full",
            "--show-leak-kinds=all",
            "--track-origins=yes",
            "--errors-for-leak-kinds=all",
            "--error-exitcode=1",
          }, " ")

          local command = string.format(
            "g++ -std=c++17 -g -O0 -Wall -Wextra %s -o %s && %s %s",
            vim.fn.shellescape(source),
            vim.fn.shellescape(executable),
            valgrind_options,
            vim.fn.shellescape(executable)
          )

          vim.cmd("split")
          vim.cmd.terminal(command)
        end,
        "🔍 Executar com Valgrind",
      },
    },

    rust = {
      name = "🦀 Code",

      p = {
        function()
          vim.cmd("split term://evcxr")
        end,
        "🦀 Abrir Rust REPL",
      },

      r = {
        function()
          vim.cmd("Cargo run")
          vim.cmd("startinsert")
        end,
        "▶️ Executar projeto",
      },

      D = {
        function()
          vim.cmd("RustDebuggables")
        end,
        "🐞 Listar debugáveis",
      },

      h = {
        function()
          vim.cmd("RustHoverActions")
        end,
        "📖 Ações de hover",
      },

      n = {
        function()
          vim.cmd("RustRunnables")
        end,
        "🏃 Listar executáveis",
      },
    },

    go = {
      name = "🐹 Code",

      p = {
        function()
          vim.cmd("split term://gore")
        end,
        "🐹 Abrir Go REPL",
      },

      r = {
        function()
          vim.cmd("!go run %")
        end,
        "▶️ Executar arquivo",
      },
    },

    julia = {
      name = "🔵 Code",

      p = {
        function()
          vim.cmd("split term://julia -i")
        end,
        "🔵 Abrir Julia REPL",
      },

      r = {
        function()
          vim.cmd("!julia %")
        end,
        "▶️ Executar arquivo",
      },
    },

    octave = {
      name = "📐 Code",

      p = {
        function()
          vim.cmd("split term://octave --persist")
        end,
        "📐 Abrir Octave REPL",
      },

      r = {
        function()
          vim.cmd("!octave %")
        end,
        "▶️ Executar arquivo",
      },
    },

    maple = {
      name = "🍁 Code",

      p = {
        function()
          vim.cmd("split term://maple")
        end,
        "🍁 Abrir Maple REPL",
      },

      r = {
        function()
          vim.cmd("!maple -q %")
        end,
        "▶️ Executar arquivo",
      },
    },

    sh = {
      name = "🐚 Code",

      p = {
        function()
          vim.cmd("split term://bash")
        end,
        "🐚 Abrir Bash",
      },

      r = {
        function()
          vim.cmd("!bash %")
        end,
        "▶️ Executar script",
      },
    },

    javascript = {
      name = "🟨 Code",

      r = {
        function()
          vim.cmd("!node %")
        end,
        "▶️ Executar com Node.js",
      },
    },

    kotlin = {
      name = "🟣 Code",

      p = {
        function()
          vim.cmd("split term://kotlinc")
        end,
        "🟣 Abrir Kotlin REPL",
      },

      r = {
        function()
          local source = vim.fn.shellescape(vim.api.nvim_buf_get_name(bufnr))

          local jar = vim.fn.shellescape(
            vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":r")
              .. ".jar"
          )

          vim.cmd(
            string.format("!kotlinc %s -include-runtime -d %s", source, jar)
          )
        end,
        "🔨 Compilar arquivo",
      },
    },
    cs = {
      name = "󰌛 Code",

      r = {
        function()
          vim.cmd("update")

          local csproj = vim.fs.find(function(name)
            return name:match("%.csproj$") ~= nil
          end, {
            path = vim.api.nvim_buf_get_name(bufnr),
            upward = true,
            type = "file",
          })[1]

          if not csproj then
            vim.notify(
              "Nenhum arquivo .csproj encontrado",
              vim.log.levels.WARN
            )
            return
          end

          local command = string.format(
            "dotnet run --project %s",
            vim.fn.shellescape(csproj)
          )

          vim.cmd("split")
          vim.cmd.terminal(command)
        end,
        "▶️ Executar projeto",
      },

      b = {
        function()
          vim.cmd("update")

          local csproj = vim.fs.find(function(name)
            return name:match("%.csproj$") ~= nil
          end, {
            path = vim.api.nvim_buf_get_name(bufnr),
            upward = true,
            type = "file",
          })[1]

          if not csproj then
            vim.notify(
              "Nenhum arquivo .csproj encontrado",
              vim.log.levels.WARN
            )
            return
          end

          local command =
            string.format("dotnet build %s", vim.fn.shellescape(csproj))

          vim.cmd("split")
          vim.cmd.terminal(command)
        end,
        "🔨 Compilar projeto",
      },

      t = {
        function()
          vim.cmd("split")
          vim.cmd.terminal("dotnet test")
        end,
        "🧪 Executar testes",
      },

      w = {
        function()
          vim.cmd("update")
          vim.cmd("split")
          vim.cmd.terminal("dotnet watch run")
        end,
        "👁️ Executar com watch",
      },

      c = {
        function()
          vim.cmd("split")
          vim.cmd.terminal("dotnet clean")
        end,
        "🧹 Limpar projeto",
      },
    },
    make = {
      name = "🛠️ Build",

      m = {
        function()
          vim.cmd("update")
          vim.cmd("split")
          vim.cmd.terminal(PKG_CONFIG .. "make")
        end,
        "🛠️ make",
      },

      c = {
        function()
          vim.cmd("split")
          vim.cmd.terminal(PKG_CONFIG .. "make clean")
        end,
        "🧹 make clean",
      },

      r = {
        function()
          vim.cmd("split")
          vim.cmd.terminal(PKG_CONFIG .. "make run")
        end,
        "▶️ make run",
      },

      t = {
        function()
          vim.cmd("split")
          vim.cmd.terminal(PKG_CONFIG .. "make test")
        end,
        "🧪 make test",
      },
    },

    cmake = {
      name = "⚙️ CMake",

      g = {
        function()
          vim.cmd("update")
          vim.cmd("split")
          vim.cmd.terminal(PKG_CONFIG .. "cmake -S . -B build")
        end,
        "⚙️ Gerar build",
      },

      b = {
        function()
          vim.cmd("split")
          vim.cmd.terminal("cmake --build build")
        end,
        "🔨 Compilar",
      },

      r = {
        function()
          vim.cmd("split")
          vim.cmd.terminal(PKG_CONFIG .. "cmake --build build && ./build/")
        end,
        "▶️ Compilar",
      },

      c = {
        function()
          vim.cmd("split")
          vim.cmd.terminal("rm -rf build")
        end,
        "🧹 Limpar build",
      },

      t = {
        function()
          vim.cmd("split")
          vim.cmd.terminal("ctest --test-dir build")
        end,
        "🧪 Executar testes",
      },
    },

    vala = {
      name = "💚 Code",

      r = {
        function()
          vim.cmd("update")

          local file = vim.fn.expand("%:p")
          local exe = vim.fn.expand("%:p:r")

          vim.cmd("split")
          vim.cmd.terminal(
            string.format(
              "valac %s && %s",
              vim.fn.shellescape(file),
              vim.fn.shellescape(exe)
            )
          )
        end,
        "▶️ Compilar e executar",
      },

      b = {
        function()
          vim.cmd("update")

          local file = vim.fn.expand("%:p")

          vim.cmd("split")
          vim.cmd.terminal("valac " .. vim.fn.shellescape(file))
        end,
        "🔨 Compilar",
      },

      d = {
        function()
          vim.cmd("update")

          local file = vim.fn.expand("%:p")

          vim.cmd("split")
          vim.cmd.terminal("valac --debug " .. vim.fn.shellescape(file))
        end,
        "🐞 Compilar com debug",
      },

      c = {
        function()
          local exe = vim.fn.expand("%:p:r")

          vim.fn.delete(exe)

          vim.notify("🧹 Binário removido")
        end,
        "🧹 Limpar binário",
      },

      g = {
        function()
          vim.cmd("update")

          local file = vim.fn.expand("%:p")
          local exe = vim.fn.expand("%:p:r")

          vim.cmd("split")
          vim.cmd.terminal(
            string.format(
              "valac --pkg gtk4 %s && %s",
              vim.fn.shellescape(file),
              vim.fn.shellescape(exe)
            )
          )
        end,
        "🪟 Compilar GTK4",
      },

      a = {
        function()
          vim.cmd("update")

          local file = vim.fn.expand("%:p")
          local exe = vim.fn.expand("%:p:r")

          vim.cmd("split")
          vim.cmd.terminal(
            string.format(
              "valac --pkg gtk4 --pkg libadwaita-1 %s && %s",
              vim.fn.shellescape(file),
              vim.fn.shellescape(exe)
            )
          )
        end,
        "🧩 Compilar Adwaita",
      },
    },

    pascal = {
      name = "🅿️ Code",

      r = {
        function()
          vim.cmd("update")

          local file = vim.fn.expand("%:p")
          local exe = vim.fn.expand("%:p:r")

          vim.cmd("split")
          vim.cmd.terminal(
            string.format(
              "fpc %s && %s",
              vim.fn.shellescape(file),
              vim.fn.shellescape(exe)
            )
          )
        end,
        "▶️ Compilar e executar",
      },

      b = {
        function()
          vim.cmd("update")

          local file = vim.fn.expand("%:p")

          vim.cmd("split")
          vim.cmd.terminal("fpc " .. vim.fn.shellescape(file))
        end,
        "🔨 Compilar",
      },

      B = {
        function()
          vim.cmd("update")

          local file = vim.fn.expand("%:p")

          vim.cmd("split")
          vim.cmd.terminal("fpc -B " .. vim.fn.shellescape(file))
        end,
        "♻️ Recompilar",
      },

      d = {
        function()
          local exe = vim.fn.expand("%:p:r")

          vim.cmd("split")
          vim.cmd.terminal("gdb " .. vim.fn.shellescape(exe))
        end,
        "🐞 Debug",
      },
    },
    java = {
      normal = {
        name = "☕ Code",

        p = {
          function()
            vim.cmd("split term://jshell")
          end,
          "☕ Abrir JShell",
        },

        o = {
          function()
            require("jdtls").organize_imports()
          end,
          "📦 Organizar imports",
        },

        v = {
          function()
            require("jdtls").extract_variable()
          end,
          "🧩 Extrair variável",
        },

        c = {
          function()
            require("jdtls").extract_constant()
          end,
          "🔒 Extrair constante",
        },

        t = {
          function()
            require("jdtls").test_class()
          end,
          "🧪 Testar classe",
        },

        n = {
          function()
            require("jdtls").test_nearest_method()
          end,
          "🎯 Testar método mais próximo",
        },
      },

      visual = {
        name = "☕ Code",

        v = {
          function()
            require("jdtls").extract_variable(true)
          end,
          "🧩 Extrair variável selecionada",
        },

        c = {
          function()
            require("jdtls").extract_constant(true)
          end,
          "🔒 Extrair constante selecionada",
        },

        m = {
          function()
            require("jdtls").extract_method(true)
          end,
          "🛠️ Extrair método selecionado",
        },
      },
    },
  }

  if fname == "Cargo.toml" then
    keymaps.rust.u = {
      function()
        require("crates").upgrade_all_crates()
      end,
      "⬆️ Atualizar todas as crates",
    }
  end

  if ft == "java" then
    register_keymaps("n", keymaps.java.normal, bufnr)
    register_keymaps("v", keymaps.java.visual, bufnr)
    return
  end

  if keymaps[ft] then
    register_keymaps("n", keymaps[ft], bufnr)
  end
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("CodeRunnerKeymaps", {
    clear = true,
  }),

  pattern = "*",

  callback = function(event)
    local bufnr = event.buf

    vim.schedule(function()
      if
        vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_loaded(bufnr)
      then
        CodeRunner(bufnr)
      end
    end)
  end,

  desc = "⌨️ Registra atalhos de execução por linguagem",
})
