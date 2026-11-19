lua vim.cmd.edit(vim.lsp.log.get_filename())

`:LspLog` era um comando do `nvim-lspconfig` que foi removido nas versões recentes. Use direto a API:

```vim
:lua vim.cmd.edit(vim.lsp.log.get_filename())
```

Ou pelo shell, já que o path é fixo:

```bash
tail -f ~/.local/state/nvim/lsp.log
```

Se quiser ver menos ruído, ajuste o nível de log antes de reproduzir o problema:

```lua
vim.lsp.set_log_level("debug")
```
cat /home/ivan/.local/state/nvim-pde/logs/lsp.log



```{vim}
   :lua vim.cmd.edit(vim.lsp.get_log_path())
```


```{vim}
   :checkhealth vim.lsp
```

