local function smart_close(buf)
  -- tenta fechar a janela atual; se o Vim recusar por ser a última
  -- (E444), cai pro fallback de descartar o buffer em vez de propagar o erro
  local ok_close = pcall(vim.cmd.close)
  if ok_close then
    return
  end

  local ok_tabclose = pcall(vim.cmd.tabclose)
  if ok_tabclose then
    return
  end

  -- última janela do último tab: não dá pra fechar, só descarta o buffer
  vim.cmd.bdelete({ buf, bang = true })
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("pde_close_with_q", { clear = true }),
  pattern = {
    "adbbridge",
    "cheat",
    "checkhealth",
    "ClangdTypeHierarchy",
    "copilot.*",
    "copilotlog",
    "floggraph",
    "fugitive",
    "git",
    "gitcommit",
    "glowpreview",
    "help",
    "lspinfo",
    "man",
    "neoai-input",
    "neoai-output",
    "neotest-output",
    "neotest-summary",
    "noice",
    "notify",
    "OverseerForm",
    "OverseerList",
    "qf",
    "query",
    "scratch",
    "spectre_panel",
    "startuptime",
    "toggleterm",
    "tsplayground",
    "vim",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", function()
      smart_close(event.buf)
    end, {
      buffer = event.buf,
      silent = true,
      nowait = true,
      desc = "Close window",
    })
  end,
  desc = "Close utility windows with q",
})

-- Terminal buffers não passam por FileType="term" no Neovim (buftype=terminal,
-- filetype normalmente fica vazio). Precisa de TermOpen.
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup(
    "pde_close_terminal_with_q",
    { clear = true }
  ),
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", function()
      smart_close(event.buf)
    end, {
      buffer = event.buf,
      silent = true,
      nowait = true,
      desc = "Close window",
    })
  end,
  desc = "Close terminal windows with q",
})
