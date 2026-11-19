return {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/kotlin-language-server" },
  -- Força JDK 17 explicitamente. O kotlin-language-server embute um
  -- compilador Kotlin (2.1.0) cujo parser de versão de Java não entende
  -- major versions novas (ex: JDK 26 -> "IllegalArgumentException: 26.0.2"
  -- em JavaVersion.parse). Depender do jenv/PATH herdado pelo processo que
  -- o Neovim spawna é frágil - aqui fixamos direto.
  -- Ajuste o caminho pro que "jenv versions" mostrar pra 17.x na sua máquina.
  cmd_env = {
    JAVA_HOME = "/home/ivan/.jenv/versions/17",
  },
  filetypes = { "kotlin" },
  single_file_support = false,

  root_markers = {
    "settings.gradle",
    "settings.gradle.kts",
    "build.gradle",
    "build.gradle.kts",
    "pom.xml",
    ".git",
  },

  init_options = {
    storagePath = vim.fn.stdpath("cache") .. "/kotlin-ls",
  },

  settings = {
    kotlin = {
      compiler = {
        jvm = {
          -- deve bater com sourceCompatibility/targetCompatibility do
          -- build.gradle do módulo Android (AGP 8.x geralmente usa 17)
          target = "17",
        },
      },
      completion = {
        snippets = { enabled = true },
      },
      linting = {
        debounceTime = 250,
      },
      indexing = {
        enabled = true,
      },
    },
  },
}
