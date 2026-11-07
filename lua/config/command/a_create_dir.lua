vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup(
    "pde_auto_create_directory",
    { clear = true }
  ),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end

    local uv = vim.uv or vim.loop
    local file = uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
  desc = "Create missing parent directories before saving",
})
