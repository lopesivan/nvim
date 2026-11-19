-- return {
--     settings = {
--         pyright = {
--             disableOrganizeImports = true,
--         },
--         python = {
--             analysis = {
--                 ignore = { "*" },
--             },
--         },
--     },
-- }

return {
  settings = {
    pyright = {
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "basic",
        autoImportCompletions = true,
      },
    },
  },
}
