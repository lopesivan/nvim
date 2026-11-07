return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "jbyuki/one-small-step-for-vimkind",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    local utils = require("my.utils")

    -- dap.set_log_level("TRACE") -- descomente para depurar (:DapShowLog)

    ---------------------------------------------------------------------------
    -- Helpers
    ---------------------------------------------------------------------------
    local function pick_binary()
      local default = vim.fn.getcwd() .. "/build/"
      local path = vim.fn.input("Binário: ", default, "file")
      if path == "" then
        return dap.ABORT
      end
      return path
    end

    local function prompt_args()
      return vim.split(vim.fn.input("Args: "), " ", { trimempty = true })
    end

    -- pick_process se disponível; senão pede o PID manualmente
    local function pick_pid()
      local ok, du = pcall(require, "dap.utils")
      if ok and du.pick_process then
        return du.pick_process()
      end
      return tonumber(vim.fn.input("PID: "))
    end

    local function debug_assembly()
      local assembly = utils.get_debug_assembly()
      print("Assembly file: " .. tostring(assembly))
      return assembly
    end

    -- Quando o nvim abre por um symlink (/workspace/...) e o binário foi
    -- compilado pelo caminho real (/home/...), mapeia real -> caminho aberto.
    local function source_map()
      local cwd = vim.fn.getcwd()
      local real = vim.fn.resolve(cwd)
      if real ~= cwd then
        return { [real] = cwd }
      end
      -- bind mount (resolve não detecta): /workspace/work == /home/ivan/work
      local ws = "/workspace/work"
      if vim.startswith(cwd, ws) then
        return { ["/home/ivan/work"] = ws }
      end
      return nil -- tabela vazia vira [] no JSON e o codelldb rejeita
    end

    ---------------------------------------------------------------------------
    -- Adapters
    ---------------------------------------------------------------------------
    dap.adapters.coreclr = {
      type = "executable",
      command = utils.get_netcoredbg_path(),
      args = { "--interpreter=vscode" },
    }

    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = utils.get_codelldb(),
        args = { "--port", "${port}" },
      },
    }

    dap.adapters.nlua = function(callback, config)
      callback({
        type = "server",
        host = config.host or "127.0.0.1",
        port = config.port or 8086,
      })
    end

    ---------------------------------------------------------------------------
    -- Configurations
    ---------------------------------------------------------------------------
    dap.configurations.cs = {
      {
        type = "coreclr",
        name = "launch - netcoredbg",
        request = "launch",
        program = debug_assembly,
      },
      {
        type = "coreclr",
        name = "Attach to Process",
        request = "attach",
        processId = pick_pid,
      },
    }

    dap.configurations.rust = {
      {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = debug_assembly,
        cwd = vim.fn.getcwd(),
        stopOnEntry = false,
        args = {},
        sourceMap = source_map(),
      },
    }

    dap.configurations.c = {
      {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = pick_binary,
        cwd = vim.fn.getcwd(),
        --stopOnEntry = true, -- binary
        stopOnEntry = false, -- code C
        sourceMap = source_map(),
      },
      {
        name = "Launch file (with args)",
        type = "codelldb",
        request = "launch",
        program = pick_binary,
        args = prompt_args,
        cwd = vim.fn.getcwd(),
        --stopOnEntry = true, -- binary
        stopOnEntry = false, -- code C
        sourceMap = source_map(),
      },
      {
        name = "Attach to process",
        type = "codelldb",
        request = "attach",
        pid = pick_pid,
        cwd = vim.fn.getcwd(),
        sourceMap = source_map(),
      },
    }

    dap.configurations.cpp = dap.configurations.c

    dap.configurations.lua = {
      {
        type = "nlua",
        request = "attach",
        name = "Attach to Neovim",
        host = "127.0.0.1",
        port = 8086,
      },
    }

    ---------------------------------------------------------------------------
    -- UI
    ---------------------------------------------------------------------------
    dapui.setup()

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    ---------------------------------------------------------------------------
    -- Keybindings
    ---------------------------------------------------------------------------
    local map = vim.keymap.set
    map("n", "<F5>", dap.continue, { desc = "Start/Continue Debugging" })
    map("n", "<F6>", dap.step_over, { desc = "Step Over" })
    map("n", "<F7>", dap.step_into, { desc = "Step Into" })
    map("n", "<F8>", dap.step_out, { desc = "Step Out" })
    map(
      "n",
      "<Leader>db",
      dap.toggle_breakpoint,
      { desc = "Toggle Breakpoint" }
    )
    map("n", "<Leader>B", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Set Conditional Breakpoint" })
    map(
      "n",
      "<Leader>dr",
      dap.repl.open,
      { desc = "Open Debug Console (REPL)" }
    )
    map("n", "<Leader>dt", dap.terminate, { desc = "Stop Debugging" })
    map("n", "<Leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
    map(
      { "n", "v" },
      "<Leader>de",
      dapui.eval,
      { desc = "Evaluate Expression" }
    )
    map("n", "<Leader>ds", function()
      dapui.open({ layout = 2 })
    end, { desc = "Open Scopes Panel" })
    map("n", "<Leader>dl", function()
      require("osv").launch({ port = 8086 })
    end, { desc = "Launch Lua debug server (osv)" })
  end,
}
