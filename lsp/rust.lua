-- ~/.config/nvim/lua/lsp/rust.lua
return {
    settings = {
        ["rust-analyzer"] = {
            check = {
                command = "clippy",
            },
        },
    },
}
