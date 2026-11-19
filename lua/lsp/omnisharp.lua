return {
    handlers = {
        ["textDocument/definition"] = require("omnisharp_extended").definition_handler,

        ["textDocument/typeDefinition"] = require("omnisharp_extended").type_definition_handler,

        ["textDocument/references"] = require("omnisharp_extended").references_handler,

        ["textDocument/implementation"] = require("omnisharp_extended").implementation_handler,
    },

    settings = {
        omnisharp = {
            enable_editorconfig_support = true,
            enable_ms_build_load_projects_on_demand = false,
            enable_roslyn_analyzers = true,
            organize_imports_on_format = true,
            enable_import_completion = true,
            sdk_include_prereleases = true,
            analyze_open_documents_only = true,
        },
    },
}
