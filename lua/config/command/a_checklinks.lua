--[[
**Como usar o comando `:CheckLinks`:**

O comando recebe **um argumento obrigatório**: o caminho de um arquivo (qualquer arquivo texto — markdown, html, código, etc). Ele varre esse arquivo procurando URLs `http://` ou `https://`, e testa cada uma com `curl` pra ver se está no ar.

```vim
:CheckLinks caminho/do/arquivo.md
```

Como `complete = "file"` está configurado, você pode digitar `:CheckLinks ` e apertar `<Tab>` para autocompletar o caminho do arquivo (inclusive arquivos do diretório atual).

**O que acontece ao rodar:**

1. Abre uma nova split vertical (`vnew`) com um buffer temporário (`nofile`, descartável ao fechar).
2. Mostra quantas URLs únicas foram encontradas no arquivo.
3. Dispara requisições `curl` em paralelo (assíncrono, via `jobstart`) para cada URL, simulando um user-agent de navegador real (rotacionando entre 3 opções) para evitar bloqueios de alguns servidores.
4. Conforme cada requisição termina, adiciona uma linha no buffer resultado no formato:
   ```
   200 https://exemplo.com
   404 https://outro-exemplo.com/pagina-morta
   ```
5. Ao final, mostra `Concluído: N URL(s) verificadas.`

**Exemplo prático no seu fluxo:** se você estiver editando um `README.md` ou documento com vários links, roda `:CheckLinks README.md` e recebe uma lista rápida de quais links ainda respondem e quais estão quebrados (404, timeout, etc), sem sair do Neovim.
]]

vim.api.nvim_create_user_command("CheckLinks", function(opts)
  if vim.fn.executable("curl") ~= 1 then
    vim.notify(
      "O executável 'curl' não foi encontrado no PATH",
      vim.log.levels.ERROR
    )
    return
  end

  local uv = vim.uv or vim.loop
  local path = vim.fn.fnamemodify(opts.args, ":p")
  local fd, open_error = uv.fs_open(path, "r", 438)
  if not fd then
    vim.notify(
      ("Não foi possível abrir %s: %s"):format(
        path,
        open_error or "erro desconhecido"
      ),
      vim.log.levels.ERROR
    )
    return
  end

  local stat = uv.fs_fstat(fd)
  local data = stat and uv.fs_read(fd, stat.size, 0) or nil
  uv.fs_close(fd)

  if not data then
    vim.notify(
      "Não foi possível ler o arquivo: " .. path,
      vim.log.levels.ERROR
    )
    return
  end

  local urls = {}
  local seen = {}
  for url in data:gmatch("https?://[^%s<>%[%]\"']+") do
    url = url:gsub("[),.;:!?]+$", "")
    if not seen[url] then
      seen[url] = true
      urls[#urls + 1] = url
    end
  end

  vim.cmd("vnew")
  local result_buf = vim.api.nvim_get_current_buf()
  vim.bo[result_buf].bufhidden = "wipe"
  vim.bo[result_buf].buftype = "nofile"
  vim.bo[result_buf].buflisted = false
  vim.bo[result_buf].swapfile = false
  vim.bo[result_buf].filetype = "checklinks"

  vim.api.nvim_buf_set_lines(result_buf, 0, -1, false, {
    ("URLs encontradas: %d"):format(#urls),
    "",
  })

  if #urls == 0 then
    return
  end

  local user_agents = {
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/124 Safari/537.36",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/124 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 Safari/605.1.15",
  }
  local completed = 0

  local function append_result(line)
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(result_buf) then
        vim.api.nvim_buf_set_lines(result_buf, -1, -1, false, { line })
      end
    end)
  end

  for index, url in ipairs(urls) do
    local output = {}
    vim.fn.jobstart({
      "curl",
      "--silent",
      "--show-error",
      "--location",
      "--insecure",
      "--output",
      "/dev/null",
      "--write-out",
      "%{http_code} %{url_effective}",
      "--user-agent",
      user_agents[((index - 1) % #user_agents) + 1],
      url,
    }, {
      stdout_buffered = true,
      stderr_buffered = true,
      on_stdout = function(_, lines)
        output = lines or {}
      end,
      on_exit = function(_, exit_code)
        completed = completed + 1
        local result = table.concat(output, ""):gsub("%s+$", "")
        if result == "" then
          result = ("ERR(%d) %s"):format(exit_code, url)
        end
        append_result(result)

        if completed == #urls then
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(result_buf) then
              vim.api.nvim_buf_set_lines(result_buf, -1, -1, false, {
                "",
                ("Concluído: %d URL(s) verificadas."):format(completed),
              })
            end
          end)
        end
      end,
    })
  end
end, {
  nargs = 1,
  complete = "file",
  desc = "Check HTTP status codes for links in a file",
})
