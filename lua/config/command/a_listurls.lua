vim.api.nvim_create_user_command("ListUrls", function(opts)
  if vim.fn.executable("lynx") ~= 1 then
    vim.notify("O executável 'lynx' não foi encontrado no PATH", vim.log.levels.ERROR)
    return
  end

  local url = opts.args
  if url == "" then
    vim.notify("Uso: :ListUrls <url>", vim.log.levels.ERROR)
    return
  end

  vim.cmd("vnew")
  local result_buf = vim.api.nvim_get_current_buf()
  vim.bo[result_buf].bufhidden = "wipe"
  vim.bo[result_buf].buftype = "nofile"
  vim.bo[result_buf].buflisted = false
  vim.bo[result_buf].swapfile = false
  vim.bo[result_buf].filetype = "listurls"

  vim.api.nvim_buf_set_lines(result_buf, 0, -1, false, {
    ("URLs de: %s"):format(url),
    "",
  })

  local output = {}
  vim.fn.jobstart({ "lynx", "-dump", "-listonly", url }, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, lines)
      output = lines or {}
    end,
    on_exit = function(_, exit_code)
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(result_buf) then
          return
        end
        if exit_code ~= 0 or #output == 0 then
          vim.api.nvim_buf_set_lines(result_buf, -1, -1, false, {
            ("Erro ao processar %s (exit code %d)"):format(url, exit_code),
          })
          return
        end
        vim.api.nvim_buf_set_lines(result_buf, -1, -1, false, output)
      end)
    end,
  })
end, {
  nargs = 1,
  desc = "Lista as URLs de uma página usando lynx",
})

