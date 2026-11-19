
# Diretórios base
NVIM_CONFIG_DIR = /home/ivan/.local/share/nvim
LAZY_DIR        = $(NVIM_CONFIG_DIR)/lazy

# Diretórios de destino específicos
NONE_LS_DIR       = $(LAZY_DIR)/none-ls.nvim/lua/null-ls/builtins/formatting
TODO_COMMENTS_DIR = $(LAZY_DIR)/todo-comments.nvim/lua/todo-comments
SNIPPETS_DIR      = $(LAZY_DIR)/friendly-snippets/snippets/c

# Diretórios para criação
BAKEFILE_RUNNER_DIR = $(LAZY_DIR)/bakefile_runner
WXPYTHON_RUNNER_DIR = $(LAZY_DIR)/wxpython_runner
LLAMMA_DIR          = $(LAZY_DIR)/llamma

# Arquivos fonte
KTFMT_SRC                = ktfmt.lua
AUTOPEP8_SRC             = autopep8.lua
ASTYLE_SRC               = astyle.lua
XMLFORMATTER_ANDROID_SRC = ./xmlformatter.lua.1
XMLFORMATTER_STD_SRC     = ./xmlformatter.lua.2
CONFIG_SRC               = config.lua
C_JSON_SRC               = c.json
KOTLIN_ALLMAN            = kotlin_allman.lua

# CLIENT_SRC = client.lua

# Arquivos destino
XMLFORMATTER_ANDROID_DEST = xmlformatter_android.lua
XMLFORMATTER_STD_DEST     = xmlformatter_std.lua
# CLIENT_DEST = client.lua


init: clean
	echo Abra o vim!
	echo execute: make mkdirs copy

mkdirs:
	mkdir -p $(BAKEFILE_RUNNER_DIR)
	mkdir -p $(WXPYTHON_RUNNER_DIR)
	mkdir -p $(LLAMMA_DIR)

copy:
	cp $(AUTOPEP8_SRC) $(NONE_LS_DIR)/
	cp $(ASTYLE_SRC) $(NONE_LS_DIR)/
	cp $(KTFMT_SRC) $(NONE_LS_DIR)/
	cp $(KOTLIN_ALLMAN) $(NONE_LS_DIR)/
	cp $(XMLFORMATTER_ANDROID_SRC) $(NONE_LS_DIR)/$(XMLFORMATTER_ANDROID_DEST)
	cp $(XMLFORMATTER_STD_SRC) $(NONE_LS_DIR)/$(XMLFORMATTER_STD_DEST)
	cp $(CONFIG_SRC) $(TODO_COMMENTS_DIR)/
	cp $(C_JSON_SRC) $(SNIPPETS_DIR)/
	#tar xvf lopesivan.tgz -C /home/ivan/.config/nvim-pde-local
	#cp $(CLIENT_SRC) $(LAZY_DIR)/none-ls.nvim/lua/null-ls/

clean:
	rm -rf \
	$(LAZY_DIR)/none-ls.nvim \
	$(LAZY_DIR)/todo-comments.nvim \
	$(LAZY_DIR)/friendly-snippets \
	$(LAZY_DIR)/neotemplate.nvim \
	$(LAZY_DIR)/raylib-sandbox \
	$(LAZY_DIR)/adb-bridge

# eof
