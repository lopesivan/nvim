local lua_path_str =
"/home/ivan/.luaenv/versions/luajit-2.0.1/share/lua/5.1/?.lua;/home/ivan/.luaenv/versions/luajit-2.0.1/share/lua/5.1/?/init.lua;./?.lua;/home/ivan/.luaenv/versions/luajit-2.0.1/share/luajit-2.0.1/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;/home/ivan/.luarocks/share/lua/5.1/?.lua;/home/ivan/.luarocks/share/lua/5.1/?/init.lua"
local lua_cpath_str =
"/home/ivan/.luaenv/versions/luajit-2.0.1/lib/lua/5.1/?.so;./?.so;/usr/local/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so;/home/ivan/.luarocks/lib/lua/5.1/?.so"

local function merge_paths(paths)
    local result = {}
    for path in paths:gmatch("[^;]+") do
        table.insert(result, path)
    end
    return result
end

local function append_paths(neovim_paths, luarocks_paths)
    for _, path in ipairs(luarocks_paths) do
        table.insert(neovim_paths, path)
    end
end

local lua_path = merge_paths(package.path)
local lua_cpath = merge_paths(package.cpath)

append_paths(lua_path, merge_paths(lua_path_str))
append_paths(lua_cpath, merge_paths(lua_cpath_str))

package.path = table.concat(lua_path, ";")
package.cpath = table.concat(lua_cpath, ";")
