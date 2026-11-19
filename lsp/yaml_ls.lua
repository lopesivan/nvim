return {
    settings = {
        yaml = {
            keyOrdering = false,
            schemaStore = {
                enable = false,
                url = "",
            },
            schemas = require("schemastore").yaml.schemas(),
        },
    },
}
