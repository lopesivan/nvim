return {
  filetypes = { "rust" },
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
      check = {
        command = "clippy",
      },
      completion = {
        autoimport = {
          enable = true,
        },
      },
      procMacro = {
        enable = true,
      },
      lens = {
        enable = true,
        run = { enable = true },
        debug = { enable = true },
        implementations = { enable = true },
        references = {
          adt = { enable = false },
          enumVariant = { enable = false },
          method = { enable = false },
          trait = { enable = false },
        },
      },
      inlayHints = {
        bindingModeHints = {
          enable = true,
        },
        chainingHints = {
          enable = true,
        },
        closingBraceHints = {
          enable = true,
          minLines = 25,
        },
        closureReturnTypeHints = {
          enable = "with_block",
        },
        lifetimeElisionHints = {
          enable = "skip_trivial",
          useParameterNames = true,
        },
        parameterHints = {
          enable = true,
        },
        typeHints = {
          enable = true,
          hideClosureInitialization = false,
          hideNamedConstructor = false,
        },
      },
    },
  },
}
