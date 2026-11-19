-- jdtls.lua
return {
  settings = {
    java = {
      configuration = {
        runtimes = {
          {
            name = "JavaSE-1.8",
            path = vim.fn.expand("~/.config/env/jenv/versions/1.8"),
          },
          {
            name = "JavaSE-15",
            path = vim.fn.expand("~/.config/env/jenv/versions/15"),
          },
          {
            name = "JavaSE-17",
            path = vim.fn.expand("~/.config/env/jenv/versions/17"),
          },
          {
            name = "JavaSE-21",
            path = vim.fn.expand("~/.config/env/jenv/versions/21"),
            default = true,
          },
          {
            name = "JavaSE-24",
            path = vim.fn.expand("~/.config/env/jenv/versions/24"),
          },
        },
      },
    },
  },
}
