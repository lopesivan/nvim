return {
  cmd = {
    "/home/ivan/.config/nvim-pde-local/mason/bin/clangd",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--header-insertion=iwyu",
    "--header-insertion-decorators",
  },

  root_markers = {
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac",
    ".git",
  },
}
