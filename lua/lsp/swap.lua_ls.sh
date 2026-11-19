#!/usr/bin/env bash

# Caminho base (use "." se for no diretório atual)
BASE_DIR="."
LINK_NAME="$BASE_DIR/lua_ls.lua"
TARGET_MONO="$BASE_DIR/lua_ls.lua.1"
TARGET_DOTNET="$BASE_DIR/lua_ls.lua.2"

# Verifica o destino atual do link
if [ -L "$LINK_NAME" ]; then
    CURRENT_TARGET=$(readlink "$LINK_NAME")

    if [[ "$CURRENT_TARGET" == *"lua_ls.lua.1" ]]; then
        ln -sf "$TARGET_DOTNET" "$LINK_NAME"
        echo "🔁 Alternado para lua_ls.lua.2"
    else
        ln -sf "$TARGET_MONO" "$LINK_NAME"
        echo "🔁 Alternado para lua_ls.lua.1"
    fi
else
    # Se o link não existir, cria apontando para mono.lua
    ln -s "$TARGET_MONO" "$LINK_NAME"
    echo "🔗 Criado lua_ls.lua apontando para lua_ls.lua.1"
fi
