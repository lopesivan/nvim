-- config/telescope.lua

SHOULD_RELOAD_TELESCOPE = false

local M = {}

-- local function reloader()
--     if SHOULD_RELOAD_TELESCOPE then
--         RELOAD("plenary")
--         RELOAD("telescope")
--     end
-- end

local function reloader()
  if SHOULD_RELOAD_TELESCOPE then
    RELOAD("config.telescope")
  end
end

local has_nonicons = pcall(require, "nvim-nonicons")

local telescope = require("telescope")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local builtin = require("telescope.builtin")
local themes = require("telescope.themes")

-- ── helpers básicos ────────────────────────────────────────────────────────────

local function bufname()
  return vim.api.nvim_buf_get_name(0)
end

local function dirname(path)
  return vim.fs.dirname(vim.fs.normalize(path))
end

local function cwd()
  return vim.uv.cwd()
end

local function current_buffer_dir()
  local file = bufname()
  return file ~= "" and dirname(file) or cwd()
end

local function project_root()
  local path = cwd()

  if vim.fs.root then
    return vim.fs.root(path, { ".git" }) or path
  end

  local git_dir = vim.fs.find(".git", {
    path = path,
    upward = true,
    type = "directory",
  })[1]

  return git_dir and dirname(git_dir) or path
end

--- Resolve o diretório de busca de acordo com o modo.
-- ✔️ Agora você tem 4 modos claros
-- mode	comportamento
-- "cwd"	diretório atual
-- "file"	pasta do arquivo
-- "root"	raiz do projeto (.git)
-- "config"	config do Neovim
local function search_dir(mode)
  if mode == "root" then
    return project_root()
  end

  if mode == "file" then
    return current_buffer_dir()
  end

  if mode == "config" then
    -- return vim.fn.stdpath("config")
    -- return string.format("%s/%s", vim.fn.stdpath("config"), "lua")
    return "/home/ivan/.config/nvim-ide/neovim-pde"
  end

  return cwd()
end

local function with_search_dir(mode, opts)
  return vim.tbl_extend("force", { cwd = search_dir(mode) }, opts or {})
end

-- ── temas / layouts ────────────────────────────────────────────────────────────

local function dropdown(opts)
  return themes.get_dropdown(vim.tbl_extend("force", {
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,
  }, opts or {}))
end

local function ivy(opts)
  return themes.get_ivy(vim.tbl_extend("force", {
    hidden = false,
    sorting_strategy = "descending",
  }, opts or {}))
end

-- ── utilitários de ação ────────────────────────────────────────────────────────

local function notify_warn(msg)
  vim.notify(msg, vim.log.levels.WARN)
end

local function sanitize_search(search)
  if not search or search == "" then
    return nil
  end

  return vim.trim(
    search
      :gsub([[\<]], "")
      :gsub([[\>]], "")
      :gsub([[\C]], "")
      :gsub([[\c]], "")
      :gsub("^\\V", "")
      :gsub("^\\v", "")
  )
end

local function set_prompt_to_entry_value(prompt_bufnr)
  local entry = action_state.get_selected_entry()
  if not entry or type(entry) ~= "table" then
    return
  end
  action_state.get_current_picker(prompt_bufnr):reset_prompt(entry.ordinal)
end

local function open_readonly(prompt_bufnr)
  local entry = action_state.get_selected_entry()
  if not entry or not entry.path then
    return
  end
  actions.close(prompt_bufnr)
  local original_win = vim.api.nvim_get_current_win()

  vim.schedule(function()
    vim.cmd("vsplit")
    vim.cmd("enew")

    local buf = vim.api.nvim_get_current_buf()
    local win = vim.api.nvim_get_current_win()

    local lines = vim.fn.readfile(entry.path)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    vim.bo[buf].readonly = true
    vim.bo[buf].modifiable = false
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    -- filetype não é setado: nenhum FileType autocmd dispara, então nenhum LSP,
    -- ftplugin ou treesitter attach acontece. Sem syntax highlighting.

    vim.keymap.set("n", "q", function()
      vim.api.nvim_win_close(win, true)
      if vim.api.nvim_win_is_valid(original_win) then
        vim.api.nvim_set_current_win(original_win)
      end
    end, { buffer = buf, silent = true, nowait = true })
  end)
end

-- ── pickers ────────────────────────────────────────────────────────────────────

function M.edit_neovim(dir)
  local opts_without_preview

  local opts_with_preview = {
    prompt_title = "~ dotfiles ~",
    shorten_path = false,
    cwd = string.format("%s/%s", vim.fn.stdpath("config"), dir),
    layout_strategy = "flex",
    layout_config = {
      width = 0.9,
      height = 0.8,
      horizontal = { width = { padding = 0.15 } },
      vertical = { preview_height = 0.75 },
    },
    attach_mappings = function(_, map)
      map("i", "<C-y>", set_prompt_to_entry_value)
      map("i", "<M-c>", function(prompt_bufnr)
        actions.close(prompt_bufnr)
        vim.schedule(function()
          builtin.find_files(opts_without_preview)
        end)
      end)
      return true
    end,
  }

  opts_without_preview =
    vim.tbl_extend("force", vim.deepcopy(opts_with_preview), {
      previewer = false,
    })

  builtin.find_files(opts_with_preview)
end

function M.find_nvim_source()
  builtin.find_files({
    prompt_title = "~ nvim ~",
    shorten_path = false,
    cwd = "~/build/neovim/",
    layout_strategy = "horizontal",
    layout_config = { preview_width = 0.35 },
  })
end

function M.fd()
  builtin.fd({ sorting_strategy = "descending", scroll_strategy = "cycle" })
end

function M.fs()
  builtin.fd(ivy())
end

function M.builtin()
  builtin.builtin()
end

function M.git_files()
  local path = vim.fn.expand("%:h")
  builtin.git_files(dropdown({
    winblend = 5,
    cwd = path ~= "" and path or nil,
    layout_config = { width = 0.75 },
  }))
end

function M.buffer_git_files()
  builtin.git_files(dropdown({ cwd = current_buffer_dir() }))
end

function M.lsp_code_actions()
  builtin.lsp_code_actions(dropdown())
end

function M.find_files(mode, opts)
  builtin.find_files(with_search_dir(mode, opts))
end

function M.file_browser(mode, opts)
  -- aceita file_browser(opts) sem mode
  if type(mode) == "table" and opts == nil then
    mode, opts = "cwd", mode
  end

  if type(mode) ~= "string" then
    mode = "cwd"
  end
  if type(opts) ~= "table" then
    opts = {}
  end

  -- vim.api.nvim_set_hl(0, "TelescopeNormal", { fg = "#d0d0d0", bg = "#1e1e1e" })
  -- vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#5a5a5a", bg = "#1e1e1e" })
  -- vim.api.nvim_set_hl(0, "TelescopePromptNormal", { fg = "#d0d0d0", bg = "#262626" })
  -- vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#5a5a5a", bg = "#262626" })
  -- vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { fg = "#d0d0d0", bg = "#1e1e1e" })
  -- vim.api.nvim_set_hl(0, "TelescopeSelection", { fg = "#ffffff", bg = "#303030", bold = true })
  -- vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = "#87afff", bold = true })
  -- vim.api.nvim_set_hl(0, "TelescopeNormal", { fg = "#d0d0d0", bg = "#1e1e1e" })
  -- vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#5a5a5a", bg = "#1e1e1e" })
  -- vim.api.nvim_set_hl(0, "TelescopePromptNormal", { fg = "#d0d0d0", bg = "#262626" })
  -- vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#5a5a5a", bg = "#262626" })
  -- vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { fg = "#d0d0d0", bg = "#1e1e1e" })
  -- vim.api.nvim_set_hl(0, "TelescopeSelection", { fg = "#ffffff", bg = "#303030", bold = true })
  -- vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = "#87afff", bold = true })

  local function open_fb(path)
    telescope.extensions.file_browser.file_browser(vim.tbl_extend("force", {
      path = path,
      cwd = path,
      select_buffer = true,
      hidden = true,
      respect_gitignore = false,
      sorting_strategy = "ascending",
      scroll_strategy = "cycle",
      layout_config = { prompt_position = "top" },

      attach_mappings = function(prompt_bufnr, map)
        local function reopen(next_path)
          actions.close(prompt_bufnr)
          vim.schedule(function()
            open_fb(vim.fs.normalize(next_path))
          end)
        end

        map("i", "-", function()
          reopen(action_state.get_current_picker(prompt_bufnr).cwd .. "/..")
        end)
        map("i", "~", function()
          reopen(vim.fn.expand("~"))
        end)
        map("i", "<C-g>", function()
          reopen(project_root())
        end)
        map("i", "<C-b>", function()
          reopen(current_buffer_dir())
        end)

        map("n", "yy", function()
          local entry = action_state.get_selected_entry()
          local value = entry and (entry.path or entry.value)
          if value then
            vim.fn.setreg("+", value)
            vim.notify("Copiado: " .. value)
          end
        end)

        return true
      end,
    }, opts))
  end

  open_fb(search_dir(mode))
end

function M.live_grep(mode, opts)
  builtin.live_grep(with_search_dir(
    mode,
    vim.tbl_extend("force", {
      previewer = false,
    }, opts or {})
  ))
end

function M.grep_string(mode, opts)
  builtin.grep_string(with_search_dir(
    mode,
    vim.tbl_extend("force", {
      path_display = { "shorten" },
      word_match = "-w",
      previewer = false,
    }, opts or {})
  ))
end

function M.grep_last_search(mode, opts)
  local search = sanitize_search(vim.fn.getreg("/"))
  if not search then
    notify_warn("O registro de busca / está vazio")
    return
  end

  builtin.grep_string(with_search_dir(
    mode,
    vim.tbl_extend("force", {
      search = search,
      word_match = "-w",
      path_display = { "shorten" },
      previewer = false,
    }, opts or {})
  ))
end

function M.oldfiles()
  require("telescope").extensions.frecency.frecency(ivy())
end

function M.my_plugins()
  builtin.find_files({ cwd = vim.fn.stdpath("config") .. "/plugins" })
end

function M.installed_plugins()
  builtin.find_files({ cwd = vim.fn.stdpath("data") .. "/lazy/" })
end

function M.project_search()
  builtin.find_files({
    cwd = project_root(),
    previewer = false,
    layout_strategy = "vertical",
  })
end

function M.buffers()
  builtin.buffers({ shorten_path = false })
end

function M.curbuf()
  builtin.current_buffer_fuzzy_find(dropdown())
end

function M.help_tags()
  builtin.help_tags({ show_version = true })
end

function M.search_all_files()
  builtin.find_files({ find_command = { "rg", "--no-ignore", "--files" } })
end

function M.short_docs()
  builtin.find_files({
    prompt_title = "~ short docs ~",
    shorten_path = false,
    cwd = vim.fn.stdpath("config") .. "/w/shortdocs",
  })
end

function M.edit_ldoc()
  builtin.find_files({
    path_display = { "shorten", "absolute" },
    cwd = vim.fn.stdpath("config") .. "/w/md",
    prompt_title = "~ ldocs ~",
  })
end

function M.edit_pdoc()
  builtin.find_files({
    path_display = { "shorten", "absolute" },
    cwd = vim.fn.stdpath("config") .. "/w/md3",
    prompt_title = "~ pdocs ~",
  })
end

function M.my_examples()
  builtin.find_files({
    path_display = { "shorten", "absolute" },
    cwd = vim.fn.stdpath("config") .. "/w/data/example",
    attach_mappings = function(_, map)
      map("i", "<CR>", open_readonly)
      map("n", "<CR>", open_readonly)
      return true
    end,
  })
end

function M.redis_list()
  builtin.find_files(dropdown({
    prompt_title = "~ redis ~",
    find_command = { "redis-cli", "--raw", "ZREVRANGE", "vimmru", "0", "11" },
  }))
end

function M.git_status()
  builtin.git_status(dropdown())
end

function M.git_commits()
  builtin.git_commits({ winblend = 5 })
end

function M.search_only_certain_files()
  builtin.find_files({
    find_command = { "rg", "--files", "--type", vim.fn.input("Type: ") },
  })
end

local function lsp_layout()
  return {
    layout_strategy = "vertical",
    layout_config = { prompt_position = "top" },
    sorting_strategy = "ascending",
    ignore_filename = false,
  }
end

function M.lsp_references()
  builtin.lsp_references(lsp_layout())
end

function M.lsp_implementations()
  builtin.lsp_implementations(lsp_layout())
end

function M.vim_options()
  builtin.vim_options({
    layout_config = { width = 0.5 },
    sorting_strategy = "ascending",
  })
end

-- ── metatable ──────────────────────────────────────────────────────────────────

return setmetatable({}, {
  __index = function(_, k)
    reloader()

    if M[k] then
      return M[k]
    end

    local ok, custom =
      pcall(require, string.format("config.telescope.custom.%s", k))
    if ok then
      return custom
    end

    return builtin[k]
  end,
})
