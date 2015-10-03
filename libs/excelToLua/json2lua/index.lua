require "lib"
local JSON_PATH = "../xlsx2json/json"
local LUA_PATH = "/data/muse/game-01/trunk/musegame/src/app/bootstrap/static" --mac


local ignore  = dofile("../ignore.lua")
--mac
macInit(LUA_PATH,ignore)
run(JSON_PATH,LUA_PATH)

--windows
-- local LUA_PATH = "E:/data/work/muse-tools/excelToLua/lua" --windows --E:/data/work/muse-tools/excelToLua/lua  --../lua
-- winInit(LUA_PATH)
-- winRun(JSON_PATH,LUA_PATH)




