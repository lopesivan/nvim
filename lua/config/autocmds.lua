local function augroup(name)
  return vim.api.nvim_create_augroup("nde_" .. name, { clear = true })
end

-- vim.cmd [[command! LuaSnipEdit :lua require("luasnip.loaders.from_lua").edit_snippet_files()]]

local function c(command)
  return string.format("<CMD>%s<CR>", command)
end

-- local function fileExist(path)
--   local fs_stat = vim.loop.fs_stat(path)
--   return fs_stat ~= nil
-- end

-- global autocmds
local api = vim.api

local function augroup(name)
  return vim.api.nvim_create_augroup("mnv_" .. name, { clear = true })
end

api.nvim_create_user_command("LuaSnipEdit", function()
  require("luasnip.loaders.from_lua").edit_snippet_files()
end, {})

-- Check if we need to reload the file when it changed
api.nvim_create_autocmd("FocusGained", { command = [[:checktime]] })

-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = augroup "highlight_yank",
  pattern = "*",
})

-- Go to last loction when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup "last_loc",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- windows to close
vim.api.nvim_create_autocmd("FileType", {
  group = augroup "close_with_q",
  pattern = {
    "cheat",
    "noice",
    "checkhealth",
    "floggraph",
    "fugitive",
    "git",
    "ClangdTypeHierarchy",
    "gitcommit",
    "glowpreview",
    "help",
    "lspinfo",
    "man",
    "neoai-input",
    "neoai-output",
    "neotest-output",
    "neotest-summary",
    "notify",
    "OverseerForm",
    "OverseerList",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "term",
    "toggleterm",
    "tsplayground",
    "vim",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- live preview
api.nvim_create_user_command("Preview", function()
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_create_autocmd("TextChangedI", {
    group = vim.api.nvim_create_augroup("GlowChanged", { clear = true }),
    buffer = buf,
    callback = function()
      -- get file contents
      -- XXX: must find another to get the old buffer
      local buffers = vim.api.nvim_list_bufs()
      local preview_buffer
      for _, b in ipairs(buffers) do
        if vim.api.nvim_buf_is_loaded(b) and b ~= buf then
          preview_buffer = b
          break
        end
      end

      if preview_buffer == nil then
        print "cur buf not found"
        return
      end

      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local chan = vim.api.nvim_open_term(preview_buffer, {})
      local text = table.concat(lines)
      local cmd = string.format("echo '%s' | glow -", text)
      vim.fn.jobstart(cmd, {
        on_stderr = function(_, data)
          local d = table.concat(data)
          if d ~= "" then
            P("error", data)
          end
        end,
        on_stdout = function(_, data)
          vim.api.nvim_chan_send(chan, table.concat(data) .. "\r\n")
        end,
      })
    end,
  })

  vim.cmd "vnew"
  vim.cmd "wincmd w"
end, { nargs = 0 })

api.nvim_create_user_command("CheckLinks", function(opts)
  local path = opts.args
  local uv = vim.loop
  local total = 0

  local function extract_urls(text)
    local url_pattern = "(https?://[%w-_%.%?%.:/%+=&]*)"
    local urls = {}

    for url in string.gmatch(text, url_pattern) do
      table.insert(urls, url)
    end

    return urls
  end

  local function get_random_user_agent()
    local user_agents = {
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.67 Safari/537.36",
      "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:54.0) Gecko/20100101 Firefox/54.0",
      "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; AS; rv:11.0) like Gecko",
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
      "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.67 Safari/537.36",
    }

    math.randomseed(os.time())
    return user_agents[math.random(1, #user_agents)]
  end

  local function request(url, buf)
    local cmd = string.format("curl -H 'User-Agent: %s' -skL -o /dev/null -w '%%{http_code} %%{url_effective}' %s", get_random_user_agent(), url)

    vim.fn.jobstart(cmd, {
      on_stdout = function(_, data)
        data = table.concat(data)
        if data ~= "" then
          total = total + 1
          local status, uri = unpack(vim.split(data, " ", {}))
          vim.api.nvim_buf_set_lines(buf, -1, -1, false, { string.format("%s %s", status, uri) })
        end
      end,
    })
  end

  local function read_file(filepath)
    local fd = assert(uv.fs_open(filepath, "r", 438))
    local stat = assert(uv.fs_fstat(fd))
    local data = assert(uv.fs_read(fd, stat.size, 0))
    assert(uv.fs_close(fd))
    return data
  end

  local data = read_file(path)
  local urls = extract_urls(data)

  vim.cmd.vnew()
  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].buftype = "nowrite"
  vim.cmd [[
    highlight StatusCodeOK guifg=#31a11d
    highlight StatusCodeError guifg=#a81b0c
    highlight Url guifg=#00ffff
  ]]
  vim.fn.matchadd("StatusCodeOK", "\\(2\\d\\{2}\\)\\s")
  vim.fn.matchadd("StatusCodeError", "\\([0\\|4\\|5]\\d\\{2}\\)\\s")

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Total URLs = " .. #urls })
  vim.schedule(function()
    for _, url in pairs(urls) do
      request(url, buf)
    end
  end)
end, { nargs = 1, complete = "file" })

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup "auto_create_dir",
  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- don't auto comment new line
api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

--- Remove all trailing whitespace on save
local TrimWhiteSpaceGrp = api.nvim_create_augroup("TrimWhiteSpaceGrp", { clear = true })
api.nvim_create_autocmd("BufWritePre", {
  command = [[:%s/\s\+$//e]],
  group = TrimWhiteSpaceGrp,
})

-- api.nvim_create_autocmd("FileType", { pattern = "man", command = [[nnoremap <buffer><silent> q :quit<CR>]] })

-- show cursor line only in active window
local cursorGrp = api.nvim_create_augroup("CursorLine", { clear = true })
api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  pattern = "*",
  command = "set cursorline",
  group = cursorGrp,
})
api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, { pattern = "*", command = "set nocursorline", group = cursorGrp })

-- Enable spell checking for certain file types
api.nvim_create_autocmd(
  { "BufRead", "BufNewFile" },
  -- { pattern = { "*.txt", "*.md", "*.tex" }, command = [[setlocal spell<cr> setlocal spelllang=en,de<cr>]] }
  {
    pattern = { "*.txt", "*.md", "*.tex" },
    callback = function()
      vim.opt.spell = true
      vim.opt.spelllang = "pt"
      -- vim.opt.spelllang = "en,pt"
    end,
  }
)

local CodeRunner = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local fname = vim.fn.expand "%:p:t"
  local keymap_c = {} -- normal key map
  local keymap_c_v = {} -- visual key map

  if ft == "python" then
    keymap_c = {
      name = "+Code Runner",
      p = { ":split term://python<cr>", "new python terminal" },
      i = { ":split term://ipython<cr>", "new ipython terminal" },
      r = {
        c "update<CR><cmd>exec '!python3' shellescape(@%, 1)",
        "Run",
      },
      m = { c "TermExec cmd='nodemon -e py %'", "Monitor" },
      f = {
        c "lua require('utils.treesitter').goto_function(bufnr_test, 'python')",
        "Go function",
      },
    }
  elseif ft == "lua" then
    keymap_c = {
      name = "+Code Runner",
      p = { ":split term://luap<cr>", "new lua terminal" },
      r = { c "luafile %", "Run" },
      f = {
        c "lua require('utils.treesitter').goto_function(bufnr_test, 'lua')",
        "Go function",
      },
    }
  elseif ft == "rust" then
    keymap_c = {
      name = "+Code Runner",
      p = { ":split term://evcxr<cr>", "new rust terminal" },
      r = { c "execute 'Cargo run' | startinsert", "Run" },
      D = { c "RustDebuggables", "Debuggables" },
      h = { c "RustHoverActions", "Hover Actions" },
      n = { c "RustRunnables", "Runnables" },
      f = {
        c "lua require('utils.treesitter').goto_function(bufnr_test, 'rust')",
        "Go function",
      },
    }
  elseif ft == "go" then
    keymap_c = {
      name = "+Code Runner",
      p = { ":split term://gore<cr>", "new Go terminal" },
      r = { c "!go run %", "Run" },
    }
  elseif ft == "sh" then
    keymap_c = {
      name = "+Code Runner",
      p = { ":split term://bash<cr>", "new Bash terminal" },
      r = { c "!bash %", "Run" },
    }
  elseif ft == "groovy" then
    keymap_c = {
      name = "+Code Runner",
      p = { ":split term://groovysh<cr>", "new Groovy terminal" },
    }
  elseif ft == "cpp" then
    keymap_c = {
      name = "+Code Runner",
      p = { ":split term://cling<cr>", "new Cling terminal" },
    }
  elseif ft == "c" then
    keymap_c = {
      name = "+Code Runner",
      p = { ":split term://cling<cr>", "new Cling terminal" },
    }
  elseif ft == "kotlin" then
    keymap_c = {
      name = "+Code Runner",
      p = { ":split term://kotlinc<cr>", "new Go terminal" },
      r = { c "!kotlinc % -include-runtime -d %<.jar", "Run" },
    }
  elseif ft == "javascript" then
    keymap_c = {
      name = "+Code Runner",
      r = { c "!node %", "Run" },
    }
  elseif ft == "make" then
    keymap_c = {
      name = "+Code Runner",
      r = { c "!make", "Run" },
    }
  elseif ft == "cmake" then
    keymap_c = {
      name = "+Code Runner",
      r = { c "!cmake .", "Run" },
    }
  elseif ft == "typescript" or ft == "typescriptreact" or ft == "javascript" or ft == "javascriptreact" then
    keymap_c = {
      name = "+Code Runner",
      o = {
        c "TypescriptOrganizeImports",
        "Organize Imports",
      },
      r = { c "TypescriptRenameFile", "Rename File" },
      i = {
        c "TypescriptAddMissingImports",
        "Import Missing",
      },
      F = { c "TypescriptFixAll", "Fix All" },
      u = { c "TypescriptRemoveUnused", "Remove Unused" },
      R = {
        c "lua require('config.neotest').javascript_runner()",
        "Choose Test Runner",
      },
      -- s = { "<cmd>2TermExec cmd='yarn start'<cr>", "Yarn Start" },
      -- t = { "<cmd>2TermExec cmd='yarn test'<cr>", "Yarn Test" },
    }
  elseif ft == "java" then
    keymap_c = {
      name = "+Code Runner",
      p = { ":split term://jshell<cr>", "new Java terminal" },
      o = {
        c "lua require'jdtls'.organize_imports()",
        "Organize Imports",
      },
      v = {
        c "lua require('jdtls').extract_variable()",
        "Extract Variable",
      },
      c = {
        c "lua require('jdtls').extract_constant()",
        "Extract Constant",
      },
      t = {
        c "lua require('jdtls').test_class()",
        "Test Class",
      },
      n = {
        c "lua require('jdtls').test_nearest_method()",
        "Test Nearest Method",
      },
    }
    keymap_c_v = {
      name = "+Code Runner",
      v = {
        c "lua require('jdtls').extract_variable(true)",
        "Extract Variable",
      },
      c = {
        c "lua require('jdtls').extract_constant(true)",
        "Extract Constant",
      },
      m = {
        c "lua require('jdtls').extract_method(true)",
        "Extract Method",
      },
    }
  end

  if fname == "package.json" then
    keymap_c.v = {
      c "lua require('package-info').show()",
      "Show Version",
    }
    keymap_c.c = {
      c "lua require('package-info').change_version()",
      "Change Version",
    }
  end

  if fname == "Cargo.toml" then
    keymap_c.u = {
      c "lua require('crates').upgrade_all_crates()",
      "Upgrade All Crates",
    }
  end

  local whichkey = require "which-key"

  if next(keymap_c) ~= nil then
    local k = { c = keymap_c }
    local o = {
      mode = "n",
      silent = true,
      noremap = true,
      buffer = bufnr,
      prefix = "<leader>",
      nowait = true,
    }
    whichkey.register(k, o)
  end

  if next(keymap_c_v) ~= nil then
    local k = { c = keymap_c_v }
    local o = {
      mode = "v",
      silent = true,
      noremap = true,
      buffer = bufnr,
      prefix = "<leader>",
      nowait = true,
    }
    whichkey.register(k, o)
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.schedule(CodeRunner)
  end,
})

--------------------------
--------------------------
--------------------------

-- Load UltiSnips in case it was deferred via vim-plug
-- if not vim.g.did_UltiSnips_plugin and vim.fn.exists ":PlugStatus" then
--   vim.fn["plug#load"] "ultisnips"
--   vim.cmd "doautocmd FileType"
-- end

-- Abort on non-empty buffer or extant file
-- if not vim.g.did_UltiSnips_plugin or not (vim.fn.line("$") == 1 and vim.fn.getline("$") == '') or vim.fn.filereadable(vim.fn.expand("%:p")) then
--   return
-- end

-- if not vim.tbl_isempty(vim.b.projectionist) then
--   -- Loop through projections with 'skeleton' key and try each one until the
--   -- snippet expands
--   for _, value in pairs(vim.fn.projectionist#query('skeleton')) do
--     if try_insert(value) then
--       return
--     end
--   end
-- end

-- Try generic _skel template as last resort

api.nvim_create_autocmd({ "BufNewFile" }, {
  pattern = {
    "*.awk",
    -- "*.bkl",
    "*.c",
    "*.cpp",
    -- "*.chef",
    -- "*.cling",
    -- "*.cs",
    -- "*.dockerfile",
    -- "*.dosini",
    -- "*.expect",
    -- "*.generic",
    -- "*.go",
    -- "*.java",
    -- "*.journal",
    -- "*.jq",
    -- "*.kotlin",
    "*.lua",
    "*.maple",
    -- "*.md",
    "*.oc",
    -- "*.org",
    -- "*.pas",
    "*.sed",
    -- "*.sh",
    -- "*.snippets",
    -- "*.sp",
    -- "*.tasks",
    -- "*.tex",
    -- "*.ts",
    -- "*.vim",
    -- "*.yaml",
  },
  callback = function()
    local key = "skeleton"
    local query_result = key

    vim.api.nvim_feedkeys("i_" .. query_result, "n", true)
    local ctrlR = vim.api.nvim_replace_termcodes("<C-r>", true, false, true)
    local enter = vim.api.nvim_replace_termcodes("<C-m>", true, false, true)
    vim.api.nvim_feedkeys(ctrlR .. "=UltiSnips#ExpandSnippet()" .. enter, "n", true)
  end,
})

vim.api.nvim_create_user_command("WatchRun", function()
  local overseer = require "overseer"
  overseer.run_template({ name = "run script" }, function(task)
    if task then
      task:add_component { "restart_on_save", paths = { vim.fn.expand "%:p" } }
      local main_win = vim.api.nvim_get_current_win()
      overseer.run_action(task, "open vsplit")
      vim.api.nvim_set_current_win(main_win)
    else
      vim.notify("WatchRun not supported for filetype " .. vim.bo.filetype, vim.log.levels.ERROR)
    end
  end)
end, {})

--[[
]]
