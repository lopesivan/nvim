local M = {}

local function entries(dir)
  local files = {}

  for name, type in vim.fs.dir(dir) do
    if type == "file" then
      table.insert(files, vim.fs.joinpath(dir, name))
    end
  end

  table.sort(files)
  return files
end

function M.jump(offset)
  local current = vim.fn.expand("%:p")
  local dir

  if current == "" then
    dir = vim.fn.getcwd()
  else
    dir = vim.fn.fnamemodify(current, ":h")
  end

  local files = entries(dir)
  if #files == 0 then
    return
  end

  local index = 1

  if current ~= "" then
    for i, file in ipairs(files) do
      if file == current then
        index = i
        break
      end
    end

    index = ((index - 1 + offset) % #files) + 1
  end

  vim.cmd.edit(vim.fn.fnameescape(files[index]))
end

return M
