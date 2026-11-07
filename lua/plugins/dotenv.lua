-- dotenv.lua
return {
  {
    "ellisonleao/dotenv.nvim",
    -- $ echo "HELLO=local" > .env.local
    -- $ echo "HELLO=World" > .env
    -- $ echo "console.log('Hello ' + process.env.HELLO)" > index.js

    -- $ dotenvx run --env-file=.env.local --env-file=.env -- node index.js
    -- Hello local
    -- Loading .env
    -- If you prefer to not load the .env file upon opening a file, you can use the user command:

    -- :Dotenv
    -- Optionally use a file as param, if the file is not in the current directory

    -- :Dotenv PATH
    -- Inspecting an env (must load env first)
    -- :DotenvGet ENV
    event = "VeryLazy",
    opts = {
      -- will load your .env file upon loading
      -- a buffer
      enable_on_load = false,

      -- show error notification if .env file is not
      -- found and if .env is loaded
      verbose = true,
    },

    config = function(_, opts)
      local dotenv = require("dotenv")
      dotenv.setup(opts)
    end,
  },
}
