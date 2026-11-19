#!/usr/bin/env bash

cp autopep8.lua /home/ivan/.config/nvim-pde-local/lazy/none-ls.nvim/lua/null-ls/builtins/formatting/
cp astyle.lua /home/ivan/.config/nvim-pde-local/lazy/none-ls.nvim/lua/null-ls/builtins/formatting/
cp ./xmlformatter.lua.1 /home/ivan/.config/nvim-pde-local/lazy/none-ls.nvim/lua/null-ls/builtins/formatting/xmlformatter_android.lua
cp ./xmlformatter.lua.2 /home/ivan/.config/nvim-pde-local/lazy/none-ls.nvim/lua/null-ls/builtins/formatting/xmlformatter_std.lua
#cp client.lua /home/ivan/.config/nvim-pde-local/lazy/none-ls.nvim/lua/null-ls/
cp config.lua /home/ivan/.config/nvim-pde-local/lazy/todo-comments.nvim/lua/todo-comments/
cp c.json /home/ivan/.config/nvim-pde-local/lazy/friendly-snippets/snippets/c/

cd /home/ivan/.config/nvim-pde-local/lazy
mkdir bakefile_runner
mkdir wxpython_runner
mkdir llamma

exit 0
