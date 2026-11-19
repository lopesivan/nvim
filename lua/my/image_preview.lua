-- ~/.config/nvim/lua/my/image_preview.lua

local api = vim.api
local M = {}

local extensions = {
  png = true,
  jpg = true,
  jpeg = true,
  webp = true,
  gif = true,
  bmp = true,
}

local last_file = nil

local function get_image_under_cursor()
  local line = api.nvim_get_current_line()
  local col = api.nvim_win_get_cursor(0)[2] + 1

  -- Procura caminhos sem espaços na linha.
  for start_col, path in line:gmatch("()([^%s\"'<>%(%)]+)") do
    local end_col = start_col + #path - 1

    if col >= start_col and col <= end_col then
      path = path:gsub("[,;]+$", "")

      local ext = path:match("%.([%w]+)$")
      if not ext or not extensions[ext:lower()] then
        return nil
      end

      local base = vim.fn.expand("%:p:h")
      local fullpath = vim.fn.fnamemodify(path, ":p")

      if not path:match("^/") then
        fullpath = vim.fs.normalize(base .. "/" .. path)
      end

      if vim.fn.filereadable(fullpath) == 1 then
        return fullpath
      end
    end
  end

  return nil
end

function M.setup()
  local group = api.nvim_create_augroup(
    "ImagePreview",
    { clear = true }
  )

  api.nvim_create_autocmd("CursorMoved", {
    group = group,
    callback = function()
      local file = get_image_under_cursor()

      if not file or file == last_file then
        return
      end

      last_file = file

      local ok, content = pcall(vim.fn.readblob, file)
      if not ok then
        return
      end

      vim.ui.img.set(content, {
        height = 15,
        width = 30,
        col = 25,
        row = 1,
      })
    end,
  })
end

return M
