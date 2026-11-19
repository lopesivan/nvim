return {
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },

  settings = {
    typescript = {
      inlayHints = {
        parameterNames = {
          enabled = "literals",
        },

        parameterTypes = {
          enabled = true,
        },

        variableTypes = {
          enabled = true,
        },

        propertyDeclarationTypes = {
          enabled = true,
        },

        functionLikeReturnTypes = {
          enabled = true,
        },

        enumMemberValues = {
          enabled = true,
        },
      },

      preferences = {
        includeCompletionsForModuleExports = true,
        includeCompletionsForImportStatements = true,
        importModuleSpecifierPreference = "shortest",
      },
    },

    javascript = {
      inlayHints = {
        parameterNames = {
          enabled = "literals",
        },

        parameterTypes = {
          enabled = true,
        },

        variableTypes = {
          enabled = true,
        },

        propertyDeclarationTypes = {
          enabled = true,
        },

        functionLikeReturnTypes = {
          enabled = true,
        },

        enumMemberValues = {
          enabled = true,
        },
      },

      preferences = {
        includeCompletionsForModuleExports = true,
        includeCompletionsForImportStatements = true,
        importModuleSpecifierPreference = "shortest",
      },
    },
  },
}
