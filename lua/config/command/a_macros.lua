local function macro_dir()
  return string.format("%s/macros", vim.fn.stdpath("config"))
end

local function macro_path(name)
  -- evita path traversal: só permite [A-Za-z0-9_-]
  assert(name:match("^[%w_%-]+$"), "nome de macro inválido: " .. name)
  return string.format("%s/%s.macro", macro_dir(), name)
end

vim.api.nvim_create_user_command("SaveMacro", function(params)
  local name = params.args
  local dir = macro_dir()
  local file = macro_path(name)

  local content = vim.fn.getreg("q")
  local regtype = vim.fn.getregtype("q") -- 'v', 'V' ou '<CTRL-V>N'

  if vim.fn.mkdir(dir, "p") == 0 and vim.fn.isdirectory(dir) == 0 then
    vim.notify("SaveMacro: falha ao criar " .. dir, vim.log.levels.ERROR)
    return
  end

  -- grava regtype na 1a linha + conteúdo dividido em linhas reais
  local lines = { regtype }
  vim.list_extend(lines, vim.split(content, "\n", { plain = true }))

  vim.fn.writefile(lines, file) -- sobrescreve (sem "a")
  vim.notify("Macro salva: " .. file)
end, { nargs = 1 })

vim.api.nvim_create_user_command("LoadMacro", function(params)
  local name = params.args
  local file = macro_path(name)

  if vim.fn.filereadable(file) == 0 then
    vim.notify(
      "LoadMacro: arquivo não encontrado: " .. file,
      vim.log.levels.ERROR
    )
    return
  end

  local lines = vim.fn.readfile(file)
  local regtype = table.remove(lines, 1) -- primeira linha = tipo do registrador
  local content = table.concat(lines, "\n")

  vim.fn.setreg("q", content, regtype)
  vim.notify("Macro carregada: " .. file)
end, {
  nargs = 1,
  complete = function()
    local dir = macro_dir()
    local files = vim.fn.glob(dir .. "/*.macro", false, true)
    return vim.tbl_map(function(f)
      return vim.fn.fnamemodify(f, ":t:r")
    end, files)
  end,
})

vim.api.nvim_create_user_command("Reload", function()
  vim.cmd("source $MYVIMRC")
end, {})
