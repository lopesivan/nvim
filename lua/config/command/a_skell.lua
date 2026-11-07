vim.api.nvim_create_autocmd("BufNewFile", {
  group = vim.api.nvim_create_augroup("pde_skeleton_snippets", { clear = true }),
  pattern = {
    "*.bkl",
    "*.cling",
    "*.dockerfile",
    "*.expect",
    "*.generic",
    "*.java",
    "*.jq",
    "*.lua",
    "*.maple",
    "*.oc",
    "*.pas",
    "*.dpr",
    "*.sed",
    "*.snippets",
    "*.sp",
    "*.tasks",
    "*.tex",
    "*.ts",
  },
  callback = function()
    local keys = vim.api.nvim_replace_termcodes(
      "i_skeleton<C-r>=UltiSnips#ExpandSnippet()<CR>",
      true,
      false,
      true
    )
    vim.api.nvim_feedkeys(keys, "n", false)
  end,
  desc = "Expand the default UltiSnips skeleton in new files",
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("pde_lsp_attach", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    if
      client:supports_method("textDocument/completion")
      and vim.lsp.completion
    then
      vim.lsp.completion.enable(
        true,
        client.id,
        event.buf,
        { autotrigger = true }
      )
    end

    if client:supports_method("textDocument/codeLens") then
      local group = vim.api.nvim_create_augroup(
        "pde_codelens_" .. event.buf,
        { clear = true }
      )
      vim.api.nvim_create_autocmd(
        { "BufEnter", "CursorHold", "InsertLeave" },
        {
          group = group,
          buffer = event.buf,
          callback = vim.lsp.codelens.refresh,
          desc = "Refresh LSP code lenses",
        }
      )
      vim.lsp.codelens.refresh({ bufnr = event.buf })
    end
  end,
  desc = "Enable native completion and code lenses for attached LSP clients",
})
