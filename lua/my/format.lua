-- ~/.config/nvim/lua/my/format.lua
local M = {}

M.autoformat = true
M.format_notify = false

M.opts = {
  timeout_ms = 3000,
}

function M.toggle()
  M.autoformat = not M.autoformat
  vim.notify(M.autoformat and "Format on save: ON" or "Format on save: OFF")
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

  local ret = { active = {}, available = {}, null_ls = null_ls }

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

--- @param range? { start: integer[], ["end"]: integer[] }
function M.format(range)
  local buf = vim.api.nvim_get_current_buf()
  local formatters = M.get_formatters(buf)

  local ids = vim.tbl_map(function(c)
    return c.id
  end, formatters.active)

  if #ids == 0 then
    vim.notify("Nenhum formatador LSP ativo", vim.log.levels.WARN)
    return
  end

  if M.format_notify then
    M.notify(formatters)
  end

  vim.lsp.buf.format({
    bufnr = buf,
    async = false,
    timeout_ms = M.opts.timeout_ms,
    range = range,
    filter = function(client)
      return vim.tbl_contains(ids, client.id)
    end,
  })
end

function M.format_visual()
  local s = vim.api.nvim_buf_get_mark(0, "<")
  local e = vim.api.nvim_buf_get_mark(0, ">")
  M.format({ start = s, ["end"] = e })
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
    vim.cmd("normal! \27") -- sai do visual para atualizar as marcas '< '>
    M.format_visual()
  end, { desc = "Format (range)" })
end

return M
