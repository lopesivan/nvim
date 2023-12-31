--[[

TODO:
- do the thing with auto picking shorter results if possible for conni
- I wanna add something that gives a little minus points for certain pattern

  - scratch files get mins -0.001

--]]

SHOULD_RELOAD_TELESCOPE = true

local reloader = function()
  if SHOULD_RELOAD_TELESCOPE then
    RELOAD "plenary"
    RELOAD "telescope"
  end
end

local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local themes = require "telescope.themes"

local set_prompt_to_entry_value = function(prompt_bufnr)
  local entry = action_state.get_selected_entry()
  if not entry or not type(entry) == "table" then
    return
  end

  action_state.get_current_picker(prompt_bufnr):reset_prompt(entry.ordinal)
end

local _ = pcall(require, "nvim-nonicons")

local M = {}

--[[
lua require('plenary.reload').reload_module("my_user.tele")

nnoremap <leader>en <cmd>lua require('my_user.tele').edit_neovim()<CR>
--]]
function M.edit_neovim(dir)
  local opts_with_preview, opts_without_preview

  opts_with_preview = {
    prompt_title = "~ dotfiles ~",
    shorten_path = false,
    cwd = string.format("%s/%s", vim.fn.stdpath "config", dir),

    layout_strategy = "flex",
    layout_config = {
      width = 0.9,
      height = 0.8,

      horizontal = {
        width = { padding = 0.15 },
      },
      vertical = {
        preview_height = 0.75,
      },
    },

    mappings = {
      i = {
        ["<C-y>"] = false,
      },
    },

    attach_mappings = function(_, map)
      map("i", "<c-y>", set_prompt_to_entry_value)
      map("i", "<M-c>", function(prompt_bufnr)
        actions.close(prompt_bufnr)
        vim.schedule(function()
          require("telescope.builtin").find_files(opts_without_preview)
        end)
      end)

      return true
    end,
  }

  opts_without_preview = vim.deepcopy(opts_with_preview)
  opts_without_preview.previewer = false

  require("telescope.builtin").find_files(opts_with_preview)
end

function M.find_nvim_source()
  require("telescope.builtin").find_files {
    prompt_title = "~ nvim ~",
    shorten_path = false,
    cwd = "~/build/neovim/",

    layout_strategy = "horizontal",
    layout_config = {
      preview_width = 0.35,
    },
  }
end

function M.fd()
  -- local opts = themes.get_ivy {
  --   hidden = false,
  --   sorting_strategy = "ascending",
  --   layout_config = { height = 9 },
  -- }
  require("telescope.builtin").fd {
    sorting_strategy = "descending",
    scroll_strategy = "cycle",
    layout_config = {
      -- height = 10,
    },
  }
end

function M.fs()
  local opts = themes.get_ivy { hidden = false, sorting_strategy = "descending" }
  require("telescope.builtin").fd(opts)
end

function M.builtin()
  require("telescope.builtin").builtin()
end

function M.git_files()
  local path = vim.fn.expand "%:h"
  if path == "" then
    path = nil
  end

  local width = 0.75

  local opts = themes.get_dropdown {
    winblend = 5,
    previewer = false,
    shorten_path = false,

    cwd = path,

    layout_config = {
      width = width,
    },
  }

  require("telescope.builtin").git_files(opts)
end

function M.buffer_git_files()
  require("telescope.builtin").git_files(themes.get_dropdown {
    cwd = vim.fn.expand "%:p:h",
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,
  })
end

function M.lsp_code_actions()
  local opts = themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,
  }

  require("telescope.builtin").lsp_code_actions(opts)
end

function M.live_grep()
  local lspconfig_util = require "lspconfig.util"
  local root_finder = lspconfig_util.root_pattern ".git"
  require("telescope.builtin").live_grep {
    -- shorten_path = true,
    cwd = root_finder(vim.fn.expand "%:p"),
    previewer = false,
    fzf_separator = "|>",
  }
end

function M.grep_prompt()
  local lspconfig_util = require "lspconfig.util"
  local root_finder = lspconfig_util.root_pattern ".git"
  require("telescope.builtin").grep_string {
    cwd = root_finder(vim.fn.expand "%:p"),
    path_display = { "shorten" },
    search = vim.fn.input "Grep String > ",
  }
end

function M.grep_last_search(opts)
  opts = opts or {}

  -- \<getreg\>\C
  -- -> Subs out the search things
  local register = vim.fn.getreg("/"):gsub("\\<", ""):gsub("\\>", ""):gsub("\\C", "")

  opts.path_display = { "shorten" }
  opts.word_match = "-w"
  opts.search = register

  require("telescope.builtin").grep_string(opts)
end

function M.oldfiles()
  local themes = require "telescope.themes"

  require("telescope").extensions.frecency.frecency(themes.get_ivy { hidden = false, sorting_strategy = "descending" })
end

function M.my_plugins()
  require("telescope.builtin").find_files {
    cwd = string.format("%s/%s", vim.fn.stdpath "config", "plugins"),
  }
end

function M.installed_plugins()
  require("telescope.builtin").find_files {
    cwd = vim.fn.stdpath "data" .. "/lazy/",
  }
end

function M.project_search()
  local lspconfig_util = require "lspconfig.util"
  local root_finder = lspconfig_util.root_pattern ".git"
  require("telescope.builtin").find_files {
    previewer = false,
    layout_strategy = "vertical",

    cwd = root_finder(vim.fn.expand "%:p"),
  }
end

function M.buffers()
  require("telescope.builtin").buffers {
    shorten_path = false,
  }
end

function M.curbuf()
  local opts = themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,
  }
  require("telescope.builtin").current_buffer_fuzzy_find(opts)
end

function M.help_tags()
  require("telescope.builtin").help_tags {
    show_version = true,
  }
end

function M.search_all_files()
  require("telescope.builtin").find_files {
    find_command = { "rg", "--no-ignore", "--files" },
  }
end

--------------------------------------------------------
function M.short_docs()
  require("telescope.builtin").find_files {
    prompt_title = "~ short docs ~",
    shorten_path = false,
    cwd = string.format("%s/w/%s", vim.fn.stdpath "config", "shortdocs"),

    -- layout_strategy = 'horizontal',
    -- layout_config = {
    --   preview_width = 0.75,
    -- },
  }
end

function M.edit_ldoc()
  require("telescope.builtin").find_files {
    path_display = {
      "shorten",
      "absolute",
    },
    cwd = string.format("%s/w/%s", vim.fn.stdpath "config", "md"),
    prompt_title = "~ ldocs ~",
  }
end

function M.edit_pdoc()
  require("telescope.builtin").find_files {
    path_display = {
      "shorten",
      "absolute",
    },
    cwd = "~/work/.md/",
    prompt_title = "~ pdocs ~",
  }
end

--[[
/home/ivan/.local/share/nvim
$ cat telescope-projects.txt
cppPonto2d=/workspace/cppPonto2d
kiko=/workspace/kiko
~/.local/share/nvim
:lua require'telescope'.extensions.project.project{}<CR>",

Default mappings (normal mode):
d: delete currently selected project
c: create a project (defaults to your git root if used inside a git project, otherwise will use your current working directory)
s: search inside files within your project
w: change to the selected project's directory without opening it
f: find a file within your project (this works the same as <CR>)



--]]

-- function M.my_project()
--     require("telescope").extensions.project.project {}
-- end

function M.my_examples()
  require("telescope.builtin").find_files {
    path_display = {
      "shorten",
      "absolute",
    },
    cwd = string.format("%s/w/data/%s", vim.fn.stdpath "config", "example"),
  }
end

-- function M.my_template()
--   local ft = vim.bo.ft
--
--   if vim.fn.empty(ft) then
--     ft = vim.fn.expand('%:e') -- get extension
--   end
--
--   local template_dir =
--     '~/.config/nvim/templates/' .. ft .. '/models'
--   require('telescope.builtin').find_files {
--     previewer = false,
--     layout_strategy = "vertical",
--     cwd = template_dir,
--   }
-- end

function M.redis_list()
  local opts = themes.get_dropdown {
    winblend = 10,
    prompt_title = "~ redis ~",
    border = true,
    previewer = false,
    shorten_path = false,
    -- find_command = {
    --   'redis-cli',
    --   '--raw',
    --   'ZRANGE',
    --   'vimmru',
    --   '0',
    --   '-1',
    -- },
    find_command = {
      "redis-cli",
      "--raw",
      "ZRANGE",
      "vimmru",
      "-12",
      "-1",
    },
  }
  require("telescope.builtin").find_files(opts)
end

--------------------------------------------------------

function M.example_for_prime()
  -- local Sorter = require('telescope.sorters')

  -- require('telescope.builtin').find_files {
  --   sorter = Sorter:new {
  -- }
end

function M.file_browser()
  local opts

  opts = {
    sorting_strategy = "ascending",
    scroll_strategy = "cycle",
    layout_config = {
      prompt_position = "top",
    },

    attach_mappings = function(prompt_bufnr, map)
      local current_picker = action_state.get_current_picker(prompt_bufnr)

      local modify_cwd = function(new_cwd)
        local finder = current_picker.finder

        finder.path = new_cwd
        finder.files = true
        current_picker:refresh(false, { reset_prompt = true })
      end

      map("i", "-", function()
        modify_cwd(current_picker.cwd .. "/..")
      end)

      map("i", "~", function()
        modify_cwd(vim.fn.expand "~")
      end)

      -- local modify_depth = function(mod)
      --   return function()
      --     opts.depth = opts.depth + mod
      --
      --     current_picker:refresh(false, { reset_prompt = true })
      --   end
      -- end
      --
      -- map("i", "<M-=>", modify_depth(1))
      -- map("i", "<M-+>", modify_depth(-1))

      map("n", "yy", function()
        local entry = action_state.get_selected_entry()
        vim.fn.setreg("+", entry.value)
      end)

      return true
    end,
  }

  require("telescope").extensions.file_browser.file_browser(opts)
end

function M.git_status()
  local opts = themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,
  }

  -- Can change the git icons using this.
  -- opts.git_icons = {
  --   changed = "M"
  -- }

  require("telescope.builtin").git_status(opts)
end

function M.git_commits()
  require("telescope.builtin").git_commits {
    winblend = 5,
  }
end

function M.search_only_certain_files()
  require("telescope.builtin").find_files {
    find_command = {
      "rg",
      "--files",
      "--type",
      vim.fn.input "Type: ",
    },
  }
end

function M.lsp_references()
  require("telescope.builtin").lsp_references {
    layout_strategy = "vertical",
    layout_config = {
      prompt_position = "top",
    },
    sorting_strategy = "ascending",
    ignore_filename = false,
  }
end

function M.lsp_implementations()
  require("telescope.builtin").lsp_implementations {
    layout_strategy = "vertical",
    layout_config = {
      prompt_position = "top",
    },
    sorting_strategy = "ascending",
    ignore_filename = false,
  }
end

function M.vim_options()
  require("telescope.builtin").vim_options {
    layout_config = {
      width = 0.5,
    },
    sorting_strategy = "ascending",
  }
end

return setmetatable({}, {
  __index = function(_, k)
    reloader()

    local has_custom, custom = pcall(require, string.format("config.telescope.custom.%s", k))

    if M[k] then
      return M[k]
    elseif has_custom then
      return custom
    else
      return require("telescope.builtin")[k]
    end
  end,
})
