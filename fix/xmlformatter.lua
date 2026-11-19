local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local FORMATTING = methods.internal.FORMATTING

return h.make_builtin({
  name = "xmlformatter",
  meta = {
    url = "https://github.com/ByteHamster/android-xml-formatter", -- ajuste para o fork/fonte que você usa
    description = "Formats XML files according to Android Studio's default formatting rules.",
  },
  method = FORMATTING,
  filetypes = { "xml", "xsd", "xsl", "xslt", "wsdl", "bakefile" },
  generator_opts = {
    command = "/home/linuxbrew/.linuxbrew/bin/xml-formatter",
    args = {
      "--indention",
      "2",
      "--attribute-sort",
      "--namespace-sort",
      "-",
    },
    to_stdin = true,
  },
  factory = h.formatter_factory,
})
