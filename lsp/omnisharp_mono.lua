-- ~/.config/nvim/lua/lsp/omnisharp_mono.lua
return {
    cmd = {
        "/home/ivan/.config/nvim-pde-local/mono/packages/omnisharp-mono/omnisharp-mono",
        "--languageserver",
        "--hostPID",
        tostring(vim.fn.getpid()),
    },
    settings = {
        useModernNet = false,
        monoPath = "/bin/mono",
    },
}

-- :lua print(vim.inspect(require("lspconfig").omnisharp_mono.document_config.default_config.cmd))
