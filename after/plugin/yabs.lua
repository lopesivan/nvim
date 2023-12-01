-- yabs.lua - yabs
-- Maintainer: Ivan Lopes
-- ~/.config/nvim/after/plugin

-- local cache_location = vim.fn.stdpath('cache')
-- local config_location = vim.fn.stdpath('config')
-- local local_location = vim.fn.stdpath('data')

local has_yabs, yabs = pcall(require, "yabs")
if not has_yabs then
  return
end

local console = require "config.console"

local languages = {
  kotlin = {
    tasks = {
      jar = {
        command = "kotlinc % -include-runtime -d " .. vim.fn.expand "%<" .. ".jar",
        output = "quickfix",
        opts = { open_on_run = "always" },
      },
      run = {
        command = "java -jar " .. vim.fn.expand "%<" .. ".jar",
        output = "quickfix",
        opts = { open_on_run = "always" },
      },
      clean = {
        command = "rm " .. vim.fn.expand "%<" .. ".jar",
        output = "quickfix",
        opts = { open_on_run = "always" },
      },
      build = {
        command = function()
          local source_name = vim.fn.expand "%<"
          vim.api.nvim_command "write"

          local key = nil
          local query_result = nil

          key = "make"
          query_result = vim.fn["projectionist#query_exec"](key)[1]
          local compile = query_result[2]

          key = "dispatch"
          query_result = vim.fn["projectionist#query_exec"](key)[1]
          local run = query_result[2]

          local pwd = vim.fn.expand "%:p:h"

          local cmd = "cd " .. pwd .. " && " .. compile .. " && " .. run

          console.exec(cmd)
        end,
        type = "lua",
      },
    },
  },
  -- Vala
  vala = {
    tasks = {
      c = {
        command = "valac -C " .. vim.fn.expand "%",
        output = "quickfix",
        opts = { open_on_run = "always" },
      },
      bin = {
        command = "valac " .. vim.fn.expand "%",
        output = "quickfix",
        opts = { open_on_run = "always" },
      },
      remove = {
        command = "rm " .. vim.fn.expand "%:p:r",
        output = "quickfix",
        opts = { open_on_run = "always" },
      },
      run = {
        command = vim.fn.expand "%:p:r",
        output = "quickfix",
        opts = { open_on_run = "always" },
      },
    },
  }, -- Vala

  -- Mono
  cs = {
    tasks = {
      dotnet_build = {
        command = "dotnet build",
        output = "quickfix",
        opts = { open_on_run = "always" },
      },
      dotnet_run = {
        command = "dotnet run",
        output = "quickfix",
        opts = { open_on_run = "always" },
      },
      mono_mcs = {
        command = "mcs %",
        output = "quickfix",
        opts = { open_on_run = "always" },
      },
      mono_csc = {
        command = "csc %",
        output = "quickfix",
        opts = { open_on_run = "always" },
      },
      mono_run = {
        command = "mono " .. vim.fn.expand "%:p:r" .. ".exe",
        output = "quickfix",
        opts = { open_on_run = "always" },
      },
      remove = {
        command = "rm " .. vim.fn.expand "%:p:r" .. ".exe",
        output = "quickfix",
        opts = { open_on_run = "always" },
      },
    },
  }, -- Mono
  java = {
    tasks = {
      class = {
        command = "javac %",
        output = "quickfix",
        type = "shell",
        opts = { open_on_run = "always" },
      },
      run = {
        command = "java %<",
        output = "quickfix",
        opts = { open_on_run = "always" },
      },
      build = {
        command = function()
          local source_name = vim.fn.expand "%<"
          vim.api.nvim_command "write"

          local key = nil
          local query_result = nil

          key = "make"
          query_result = vim.fn["projectionist#query_exec"](key)[1]
          local compile = query_result[2]

          key = "dispatch"
          query_result = vim.fn["projectionist#query_exec"](key)[1]
          local run = query_result[2]

          local pwd = vim.fn.expand "%:p:h"

          local cmd = "cd " .. pwd .. " && " .. compile .. " && " .. run

          console.exec(cmd)
        end,
        type = "lua",
      },
    },
  },
  cpp = {
    -- default_task = yabs.first_available("cmake_build", "make_build"),
    tasks = {
      run = {
        command = function()
          local source_name = vim.fn.expand "%<"
          local cmd = string.format("./%s", source_name)
          console.exec(cmd)
        end,
        type = "lua",
      },
      make = {
        command = function()
          require("config.nvim_dev").make {}
        end,
        type = "lua",
      },
      build = {
        command = function()
          local current_file = vim.api.nvim_buf_get_name(0)
          -- local filename_without_extension = current_file:match("(.+)%..+")
          local dirname = vim.fn.fnamemodify(current_file, ":h")
          local basename_without_extension = vim.fn.fnamemodify(current_file, ":t:r")
          vim.api.nvim_command "write"

          local key = nil
          local query_result = nil

          key = "CC"
          query_result = vim.fn["projectionist#query_exec"](key)[1]
          local compile = query_result[2]

          key = "LD"
          query_result = vim.fn["projectionist#query_exec"](key)[1]
          local link = query_result[2]

          local run = string.format("./%s", basename_without_extension)
          local cmd = "cd " .. dirname .. " && " .. compile .. " && " .. link .. " && " .. run

          console.exec(cmd)
        end,
        type = "lua",
      },
    },
  },
  c = {
    tasks = {
      run = {
        command = function()
          local source_name = vim.fn.expand "%<"
          local cmd = string.format("./%s", source_name)
          console.exec(cmd)
        end,
        type = "lua",
      },
      make = {
        command = function()
          require("config.nvim_dev").make {}
        end,
        type = "lua",
      },
      build = {
        command = function()
          local current_file = vim.api.nvim_buf_get_name(0)
          -- local filename_without_extension = current_file:match("(.+)%..+")
          local dirname = vim.fn.fnamemodify(current_file, ":h")
          local basename_without_extension = vim.fn.fnamemodify(current_file, ":t:r")
          vim.api.nvim_command "write"

          local key = nil
          local query_result = nil

          key = "CC"
          query_result = vim.fn["projectionist#query_exec"](key)[1]
          local compile = query_result[2]

          key = "LD"
          query_result = vim.fn["projectionist#query_exec"](key)[1]
          local link = query_result[2]

          local run = string.format("./%s", basename_without_extension)
          local cmd = "cd " .. dirname .. " && " .. compile .. " && " .. link .. " && " .. run

          console.exec(cmd)
        end,
        type = "lua",
      },
    },
  },
  make = {
    tasks = {
      make = {
        command = function()
          require("config.nvim_dev").make {}
        end,
        type = "lua",
      },
      run = {
        command = function()
          require("config.nvim_dev").make { "run" }
        end,
        type = "lua",
      },
      clean = {
        command = function()
          require("config.nvim_dev").make { "clean" }
        end,
        type = "lua",
      },
      test = {
        command = function()
          require("config.nvim_dev").make { "test" }
        end,
        type = "lua",
      },
      bear = {
        command = "/usr/local/bin/bear -- make",
        output = "quickfix",
        opts = { open_on_run = "always" },
      },
    },
  }, -- make
  lua = {
    tasks = {
      run = {
        command = "luafile %",
        type = "vim",
        -- output = "quickfix",
        -- output = 'echo',
        output = "quickfix",
        opts = { open_on_run = "always" },
      },
    },
  }, -- lua
  spice = {
    tasks = {
      run = {
        command = "ngspice -b %",
        output = "quickfix",
      },
    },
  }, -- spice
  sh = {
    tasks = {
      run = {
        command = "bash %",
        output = "quickfix",
      },
    },
  }, -- Sh
  bc = {
    tasks = {
      run = {
        command = "bc -q -l % <<< 'quit'",
        output = "quickfix",
      },
    },
  }, -- bc
  maple = {
    tasks = {
      run = {
        command = "maple -q %",
        output = "quickfix",
      },
    },
  }, --Maple
  octave = {
    tasks = {
      run = {
        command = "octave %",
        output = "quickfix",
      },
    },
  }, -- Octave
  ruby = {
    tasks = {
      run = {
        command = "ruby %",
        output = "quickfix",
      },
      monitor = {
        command = "nodemon -e py %",
        output = "terminal",
      },
      debug = {
        command = "ruby -m pdb %",
        output = "terminal",
      },
    },
  }, -- ruby
  rust = {
    tasks = {
      run = {
        command = "cargo run",
        output = "quickfix",
      },
      build = {
        command = "cargo build",
        output = "quickfix",
      },
      clean = {
        command = "cargo clean",
        output = "quickfix",
      },
      init = {
        command = "cargo init",
        output = "quickfix",
      },
      doc = {
        command = "cargo doc",
        output = "quickfix",
      },
      new = {
        command = "cargo new",
        output = "quickfix",
      },
      add = {
        command = "cargo add",
        output = "quickfix",
      },
      test = {
        command = "cargo test",
        output = "quickfix",
      },
      install = {
        command = "cargo install",
        output = "quickfix",
      },
      uninstall = {
        command = "cargo uninstall",
        output = "quickfix",
      },
    },
  }, -- rust
  python = {
    tasks = {
      run = {
        command = "python %",
        output = "quickfix",
      },
      monitor = {
        command = "nodemon -e py %",
        output = "terminal",
      },
      debug = {
        command = "python -m pdb %",
        output = "terminal",
      },
    },
  }, -- Python
  julia = {
    tasks = {
      run = {
        command = "julia %",
        output = "terminal",
        opts = { open_on_run = "never" },
      },
      test = {
        command = "julia -e 'using Pkg; Pkg.test()'",
        output = "terminal",
        opts = { open_on_run = "auto" },
      },
    },
  }, -- Julia
} -- languages

-- Default tasks
local tasks = {
  cmake = {
    command = "cmake .",
    output = "quickfix",
  },
  make = {
    command = "make",
    output = "quickfix",
  },
} -- tasks

local opts = {
  output_types = {
    quickfix = { open_on_run = "always" },
  },
} -- opts

yabs:setup { languages = languages, tasks = tasks, opts = opts }

-- vim: fdm=marker:sw=4:sts=4:et
