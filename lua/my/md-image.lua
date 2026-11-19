local M = {}

local current_id = nil
local current_path = nil

local function clear()
  if current_id then
    pcall(vim.ui.img.del, current_id)
    current_id, current_path = nil, nil
  end
end

local function show()
  local line = vim.api.nvim_get_current_line()
  local rel = line:match("!%[.-%]%((.-)%)")
  if not rel then
    return clear()
  end

  rel = rel:gsub("%s+.*$", "") -- remove título opcional: (img.png "titulo")
  local dir = vim.fn.expand("%:p:h")
  local path = vim.fn.fnamemodify(dir .. "/" .. rel, ":p")

  if vim.fn.filereadable(path) ~= 1 then
    return clear()
  end
  if path == current_path then
    return
  end

  clear()
  local content = vim.fn.readblob(path)
  local ok, id = pcall(vim.ui.img.set, content, {
    height = 15,
    width = 40,
    row = vim.fn.screenrow() + 1,
    col = 2,
  })
  if ok then
    current_id, current_path = id, path
  else
    vim.notify("vim.ui.img: " .. tostring(id), vim.log.levels.ERROR)
  end
end

function M.setup()
  if not vim.ui.img then
    return
  end
  local group = vim.api.nvim_create_augroup("MdImage", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "markdown",
    callback = function(args)
      vim.api.nvim_create_autocmd("CursorMoved", {
        group = group,
        buffer = args.buf,
        callback = show,
      })
      vim.api.nvim_create_autocmd({ "BufLeave", "InsertEnter" }, {
        group = group,
        buffer = args.buf,
        callback = clear,
      })
    end,
  })
end

return M
