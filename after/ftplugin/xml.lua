-- programa em lua
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.textwidth = 78
vim.bo.expandtab = true
vim.bo.autoindent = true
vim.bo.infercase = true

-- vim.opt.foldmethod = "syntax"
-- vim.opt.foldcolumn = "1"
-- vim.opt.foldlevel = 999
-- vim.opt.foldminlines = 1
-- vim.opt.foldtext = "XMLFoldText()"

-- export XMLLINT_INDENT="...."
vim.env["XMLLINT_INDENT"] = "    "

vim.opt.fillchars = "fold: "
vim.g.xml_syntax_folding = 1
vim.opt.equalprg = "xmllint --format --recover - 2>/dev/null"

vim.g.projectionist_heuristics = {
  ["pom.xml"] = {
    ["pom.xml"] = {
      ["compile"] = "mvn compile",
      ["run"] = "mvn exec:java",
      ["clean"] = "mvn clean",
      ["jar"] = "mvn jar:jar",
      ["type"] = "xml",
    },
  },
}

local items = { "compile", "run", "clean", "jar" }

for _, v in pairs(items) do
  vim.cmd(([[
nmenu Maven.%s :lua require('config.console').exec(vim.fn["projectionist#query_exec"]("%s")[1][2])
]]):format(v, v))
end

vim.api.nvim_set_keymap("n", "<F12>", "<Cmd>call Menu2Quick('Maven', 'n')<CR>", { noremap = true, silent = true })
