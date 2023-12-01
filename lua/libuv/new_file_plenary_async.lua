R "telescope"
R "plenary"

local async_static_finder = require "telescope.finders.async_static_finder"
local pickers = require "telescope.pickers"
local conf = require("telescope.config").values

local f = async_static_finder {
  ".ccls",
  ".ccls-root",
  ".clang-format",
  ".clangd",
  ".csharpierrc.json",
  ".editorconfig",
  ".exrc",
  ".gitignore",
  ".local.vimrc",
  ".luaenv-vars",
  ".nvimrc",
  ".nvimrc.lua",
  ".projectile",
  ".projections.json",
  ".pyenv-vars",
  ".solution.toml",
  ".stylua.toml",
  ".tasks",
  "CMakeLists.txt",
  "Makefile",
  "Makefile.cpp",
  "Makefile.java",
  "README.md",
  "README.md",
  "astyle.cfg",
  "build.haml",
  "build.sh",
  "build.xml",
  "cansi.projections.json",
  "cpp.projections.json",
  "custom_rules.xml",
  "gradle.projections.json",
  "local.properties",
  "package.json",
  "pom.xml",
  "prj.go",
  "prj.kotlin",
  "pubspec.yaml",
  "settings.gradle",
  "stylua.toml",
  "tsconfig.json",
}

pickers
  .new({}, {
    prompt_title = "Async Finder",
    finder = f,
    previewer = false,
    sorter = conf.file_sorter {},
  })
  :find()
