vim.api.nvim_create_user_command("Preview", function()
  if vim.fn.executable("glow") ~= 1 then
    vim.notify(
      "O executável 'glow' não foi encontrado no PATH",
      vim.log.levels.ERROR
    )
    return
  end

  local source_buf = vim.api.nvim_get_current_buf()

  vim.cmd("vnew")
  local preview_buf = vim.api.nvim_get_current_buf()
  vim.bo[preview_buf].bufhidden = "wipe"
  vim.bo[preview_buf].buftype = "nofile"
  vim.bo[preview_buf].buflisted = false
  vim.bo[preview_buf].swapfile = false
  vim.bo[preview_buf].filetype = "glowpreview"

  local function render()
    if
      not vim.api.nvim_buf_is_valid(source_buf)
      or not vim.api.nvim_buf_is_valid(preview_buf)
    then
      return
    end

    local text =
      table.concat(vim.api.nvim_buf_get_lines(source_buf, 0, -1, false), "\n")
    local output = {}
    local errors = {}

    local job_id = vim.fn.jobstart({ "glow", "-" }, {
      stdout_buffered = true,
      stderr_buffered = true,
      on_stdout = function(_, data)
        output = data or {}
      end,
      on_stderr = function(_, data)
        errors = data or {}
      end,
      on_exit = function(_, exit_code)
        vim.schedule(function()
          if not vim.api.nvim_buf_is_valid(preview_buf) then
            return
          end

          if exit_code ~= 0 then
            local message = table.concat(errors, "\n"):gsub("%s+$", "")
            vim.notify(
              message ~= "" and message or "Falha ao executar o glow",
              vim.log.levels.ERROR
            )
            return
          end

          while #output > 0 and output[#output] == "" do
            table.remove(output)
          end

          vim.bo[preview_buf].modifiable = true
          vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, output)
          vim.bo[preview_buf].modifiable = false
        end)
      end,
    })

    if job_id <= 0 then
      vim.notify("Não foi possível iniciar o glow", vim.log.levels.ERROR)
      return
    end

    vim.fn.chansend(job_id, text)
    vim.fn.chanclose(job_id, "stdin")
  end

  local group = vim.api.nvim_create_augroup(
    "pde_glow_preview_" .. source_buf,
    { clear = true }
  )
  vim.api.nvim_create_autocmd(
    { "TextChanged", "TextChangedI", "BufWritePost" },
    {
      group = group,
      buffer = source_buf,
      callback = render,
    }
  )
  vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    buffer = preview_buf,
    once = true,
    callback = function()
      pcall(vim.api.nvim_del_augroup_by_id, group)
    end,
  })

  render()
end, { desc = "Open a live Markdown preview with glow" })
