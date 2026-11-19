-- lsp/pasls.lua
-- lsp/pasls.lua
return {
  cmd = {
    "/home/ivan/git/pascal-language-server/server/pasls",
    "--save-log",
    "/tmp/pasls-nvim.log",
  },

  filetypes = {
    "pascal",
  },

  root_markers = {
    ".git",
    "*.lpi",
    "*.lpk",
    "*.lpr",
  },

  mason = false,

  cmd_env = {
    PP = "/usr/bin/ppcx64",
    FPCDIR = "/usr/share/fpcsrc/3.2.2",
    LAZARUSDIR = "/usr/share/lazarus/4.8.0",
    FPCTARGET = "linux",
    FPCTARGETCPU = "x86_64",
  },

  on_init = function(client)
    local provider = client.server_capabilities.completionProvider

    if not provider then
      return
    end

    local list_fields = {
      "triggerCharacters",
      "allCommitCharacters",
    }

    for _, field in ipairs(list_fields) do
      if type(provider[field]) ~= "table" then
        provider[field] = {}
      end
    end
  end,
}
