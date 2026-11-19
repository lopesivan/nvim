-- ~/.config/nvim/lua/my/format.lua
-- test
-- :lua print(require("my.format").supports_format(vim.lsp.get_clients({ bufnr = 0 })[1], 0))

local M = {}

M.autoformat = true
M.format_notify = false
M.notify_on_format = true

M.opts = {
  timeout_ms = 3000,
}

function M.toggle()
  M.autoformat = not M.autoformat

  vim.notify(
    M.autoformat and "Format on save: ON" or "Format on save: OFF",
    vim.log.levels.INFO,
    { title = "Formatting" }
  )
end

local function supports(client, method, bufnr)
  if client.supports_method then
    local ok, res = pcall(client.supports_method, client, method, bufnr)

    if ok then
      return res
    end
  end

  return false
end

function M.supports_format(client, bufnr)
  if not client then
    return false
  end

  return supports(client, "textDocument/formatting", bufnr)
    or supports(client, "textDocument/rangeFormatting", bufnr)
end

function M.get_formatters(bufnr)
  local ft = vim.bo[bufnr].filetype
  local null_ls = {}

  if package.loaded["null-ls"] then
    null_ls =
      require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING")
  end

  local ret = {
    active = {},
    available = {},
    null_ls = null_ls,
  }

  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if M.supports_format(client, bufnr) then
      if #null_ls == 0 or client.name == "null-ls" then
        table.insert(ret.active, client)
      else
        table.insert(ret.available, client)
      end
    end
  end

  return ret
end

function M.notify(formatters)
  local lines = { "Active:" }

  for _, client in ipairs(formatters.active) do
    local line = "- " .. client.name

    if client.name == "null-ls" and #formatters.null_ls > 0 then
      line = line
        .. " ("
        .. table.concat(
          vim.tbl_map(function(f)
            return f.name
          end, formatters.null_ls),
          ", "
        )
        .. ")"
    end

    table.insert(lines, line)
  end

  if #formatters.available > 0 then
    table.insert(lines, "")
    table.insert(lines, "Disabled:")

    for _, client in ipairs(formatters.available) do
      table.insert(lines, "- " .. client.name)
    end
  end

  vim.notify(
    table.concat(lines, "\n"),
    vim.log.levels.INFO,
    { title = "Formatting" }
  )
end

local function formatter_names(formatters)
  local names = {}

  for _, client in ipairs(formatters.active) do
    if client.name == "null-ls" and #formatters.null_ls > 0 then
      for _, source in ipairs(formatters.null_ls) do
        table.insert(names, source.name)
      end
    else
      table.insert(names, client.name)
    end
  end

  return table.concat(names, ", ")
end

--- @param range? { start: integer[], ["end"]: integer[] }
function M.format(range)
  local buf = vim.api.nvim_get_current_buf()
  local formatters = M.get_formatters(buf)

  local ids = vim.tbl_map(function(c)
    return c.id
  end, formatters.active)

  if #ids == 0 then
    vim.notify(
      "Nenhum formatador LSP ativo",
      vim.log.levels.WARN,
      { title = "Formatting" }
    )
    return
  end

  if M.format_notify then
    M.notify(formatters)
  end

  local changedtick = vim.api.nvim_buf_get_changedtick(buf)

  local ok, err = pcall(vim.lsp.buf.format, {
    bufnr = buf,
    async = false,
    timeout_ms = M.opts.timeout_ms,
    range = range,
    filter = function(client)
      return vim.tbl_contains(ids, client.id)
    end,
  })

  if not ok then
    vim.notify(
      "Erro ao formatar: " .. tostring(err),
      vim.log.levels.ERROR,
      { title = "Formatting" }
    )
    return
  end

  if not M.notify_on_format then
    return
  end

  local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")

  if filename == "" then
    filename = "[No Name]"
  end

  local changed = vim.api.nvim_buf_get_changedtick(buf) ~= changedtick

  local message

  if changed then
    message = string.format(
      "Formatado: %s\nFormatador: %s",
      filename,
      formatter_names(formatters)
    )
  else
    message = string.format(
      "Sem alterações: %s\nFormatador: %s",
      filename,
      formatter_names(formatters)
    )
  end

  vim.notify(message, vim.log.levels.INFO, { title = "Formatting" })
end

function M.format_visual()
  local s = vim.api.nvim_buf_get_mark(0, "<")
  local e = vim.api.nvim_buf_get_mark(0, ">")

  M.format({
    start = s,
    ["end"] = e,
  })
end

function M.on_attach(client, bufnr)
  if not M.supports_format(client, bufnr) then
    return
  end

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup(
      "LspFormat." .. bufnr,
      { clear = true }
    ),
    buffer = bufnr,
    callback = function()
      if M.autoformat then
        M.format()
      end
    end,
  })
end

function M.setup()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("BaseFormat", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      M.on_attach(client, args.buf)
    end,
  })

  vim.api.nvim_create_user_command("FormatToggle", M.toggle, {})

  vim.api.nvim_create_user_command("Format", function()
    M.format()
  end, {})

  vim.keymap.set("n", "ff", M.format, { desc = "Format" })

  vim.keymap.set("v", "ff", function()
    vim.cmd("normal! \27")
    M.format_visual()
  end, { desc = "Format (range)" })
end

return M
