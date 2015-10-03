--[[
    Filename:    lib.lua
    Author:      ocean 
    Datetime:    
    Description: json chang lua
--]]
--------------------------------------------------------------------------------
-- 辅助调试函数 
--------------------------------------------------------------------------------
local function dump_value_(v)
    if type(v) == "string" then
        v = "\"" .. v .. "\""
    end
    return tostring(v)
end
function string.split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end
function string.trim(input)
    input = string.gsub(input, "^[ \t\n\r]+", "")
    return string.gsub(input, "[ \t\n\r]+$", "")
end

function dump(value, desciption, nesting)
    if type(nesting) ~= "number" then nesting = 3 end

    local lookupTable = {}
    local result = {}

    local traceback = string.split(debug.traceback("", 2), "\n")
    print("dump from: " .. string.trim(traceback[3]))

    local function dump_(value, desciption, indent, nest, keylen)
        desciption = desciption or "<var>"
        local spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(dump_value_(desciption)))
        end
        if type(value) ~= "table" then
            result[#result +1 ] = string.format("%s%s%s = %s", indent, dump_value_(desciption), spc, dump_value_(value))
        elseif lookupTable[tostring(value)] then
            result[#result +1 ] = string.format("%s%s%s = *REF*", indent, dump_value_(desciption), spc)
        else
            lookupTable[tostring(value)] = true
            if nest > nesting then
                result[#result +1 ] = string.format("%s%s = *MAX NESTING*", indent, dump_value_(desciption))
            else
                result[#result +1 ] = string.format("%s%s = {", indent, dump_value_(desciption))
                local indent2 = indent.."    "
                local keys = {}
                local keylen = 0
                local values = {}
                for k, v in pairs(value) do
                    keys[#keys + 1] = k
                    local vk = dump_value_(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then keylen = vkl end
                    values[k] = v
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for i, k in ipairs(keys) do
                    dump_(values[k], k, indent2, nest + 1, keylen)
                end
                result[#result +1] = string.format("%s}", indent)
            end
        end
    end
    dump_(value, desciption, "- ", 1)

    for i, line in ipairs(result) do
        print(line)
    end
end
--[[
function serialize(t)
	local mark={}
	local assign={}
	
	local function ser_table(tbl,parent)
		mark[tbl]=parent
		local tmp={}
		for k,v in pairs(tbl) do
			local key= type(k)=="number" and "["..k.."]" or k
			if type(v)=="table" then
				local dotkey= parent..(type(k)=="number" and key or "."..key)
				if mark[v] then
					table.insert(assign,dotkey.."="..mark[v])
				else
					table.insert(tmp, key.."="..ser_table(v,dotkey))
				end
			else
				table.insert(tmp, key.."="..v)
			end
		end
		return "{"..table.concat(tmp,",").."}"
	end
 
	return "do local ret="..ser_table(t,"ret")..table.concat(assign," ").." return ret end"
end
--获取路径  
function stripfilename(filename)  
    return string.match(filename, "(.+)/[^/]*%.%w+$") --*nix system  
    --return string.match(filename, “(.+)\\[^\\]*%.%w+$”) — windows  
end 
--去除扩展名  
function stripextension(filename)  
    local idx = filename:match(".+()%.%w+$")  
    if(idx) then  
        return filename:sub(1, idx-1)  
    else  
        return filename  
    end  
end  

--获取扩展名  
function getextension(filename)  
    return filename:match(".+%.(%w+)$")  
end
]]

--------------------------------------------------------------------------------
-- json to lua 
--------------------------------------------------------------------------------
luautil = {}

--lua 序列化
function luautil.serialize(t, sort_parent, sort_child)  
    local mark={}  
    local assign={}  
      
    local function ser_table(tbl,parent)  
        mark[tbl]=parent  
        local tmp={}  
        local sortList = {};  
        for k,v in pairs(tbl) do  
            sortList[#sortList + 1] = {key=k, value=v};  
        end  
  
        if tostring(parent) == "ret" then  
            if sort_parent then table.sort(sortList, sort_parent); end  
        else  
            if sort_child then table.sort(sortList, sort_child); end  
        end  
  
        for i = 1, #sortList do  
            local info = sortList[i];  
            local k = info.key;  
            local v = info.value;  
            local key= type(k)=="number" and "["..k.."]" or k;  
            if type(v)=="table" then  
                local dotkey= parent..(type(k)=="number" and key or "."..key)  
                if mark[v] then  
                    table.insert(assign,dotkey.."="..mark[v])  
                else  
                    table.insert(tmp, "\n"..key.."="..ser_table(v,dotkey))  
                end  
            else  
                if type(v) == "string" then  
                    table.insert(tmp, key..'="'..v..'"');  
                else  
                    table.insert(tmp, key.."="..tostring(v));  
                end  
            end  
        end  
  
        return "{"..table.concat(tmp,",").."}";  
    end  
   
    return "do local ret="..ser_table(t,"ret")..table.concat(assign," ").."\nreturn ret end"  
end  
  
--lua 分割
function luautil.split(str, delimiter)  
    if (delimiter=='') then return false end  
    local pos,arr = 0, {}  
    -- for each divider found  
    for st,sp in function() return string.find(str, delimiter, pos, true) end do  
        table.insert(arr, string.sub(str, pos, st - 1))  
        pos = sp + 1  
    end  
    table.insert(arr, string.sub(str, pos))  
    return arr  
end  

--lua 写文件
function luautil.writefile(str, file)  
    os.remove(file);  
    local file=io.open(file,"ab");  
  
    local len = string.len(str);  
    local tbl = luautil.split(str, "\n");  
    for i = 1, #tbl do  
        file:write(tbl[i].."\n");  
    end  
    file:close();  
end 

--lua 格式化
function luautil.format(t)
	local head_temp = {}
	local list = {}
	local id
	list["index"] = {}
	assert(type(t[1]) == "table","excel head has errors,please check")
	for k,v in pairs(t[1]) do
		k = tonumber(k) + 1
		head_temp[k] = v
		list["index"][v] = k
	end
	for i=2,#t do
		id = t[i][head_temp[1]]
		list[id] = {}
		for j=1,#head_temp do
			list[id][j] = t[i][head_temp[j]]
		end
	end
	-- dump(list)
	-- dump(head_temp)
	return list
end

--lua 得到json文件的名字（不包含.json后缀）
function luautil.getJsonName(str)
    local len = string.len(str) -5
    return string.sub(str,1,len)
end

--lua 根据lua根目录得到导出json的lua配表
function luautil.getLuaPath( jsonFileName,luaPath )
    local file = luautil.getJsonName(jsonFileName)
    file = luaPath.."/"..file..".lua"
    return file
end

--lua获取问文件全名字
function luautil.strippath(filename)  
    return string.match(filename, ".+/([^/]*%.%w+)$") -- *nix system  
    --return string.match(filename, “.+\\([^\\]*%.%w+)$”) — *nix system  
end

--------------------------------------------------------------------------------
-- todo 
--------------------------------------------------------------------------------
function run(JSON_PATH,LUA_PATH)
    JSON = (loadfile "JSON.lua")()
    local json_file
    local out_file
    local lua_value
    -- local count = 0
    --遍历json目录
    getJsonFileTable = io.popen('find * ' .. JSON_PATH)
    for file in getJsonFileTable:lines() do 
        if string.find(file,"%.json$") then

            fileName = luautil.strippath(file)
            -- count = count + 1   
            -- assert(jsonNameTable[fileName] == nil,fileName..":file has same name,please check")
            -- jsonNameTable[fileName] = count
            json_file = io.open(file,"r")
            lua_value = JSON:decode(json_file:read("*a")) 
            lua_value = luautil.format(lua_value)
            lua_value = luautil.serialize(lua_value)
            out_file = luautil.getLuaPath(fileName,LUA_PATH)
            luautil.writefile(lua_value,out_file)
            print("exported lua successfully  -->\n",out_file)
        end
    end
    json_file:close()
end

function winRun(JSON_PATH,LUA_PATH)
    JSON = (loadfile "JSON.lua")()
    local json_file
    local out_file
    local lua_value
    --遍历json目录
    getJsonFileTable = io.popen("cd "..JSON_PATH.." && dir /b /s /a:-D")
    for file in getJsonFileTable:lines() do 
        -- print(file)
        if string.find(file,"%.json$") then
            fileName = string.match(file, ".+\\([^\\]*%.%w+)$")
            json_file = io.open(file,"r")
            lua_value = JSON:decode(json_file:read("*a"))
            lua_value = luautil.format(lua_value)
            lua_value = luautil.serialize(lua_value)
            out_file = luautil.getLuaPath(fileName,LUA_PATH)
            -- print(out_file)
            luautil.writefile(lua_value,out_file)
            print("exported lua successfully  -->\n",out_file)
        end
    end
    json_file:close()
end


-- 清楚目录下所有的lua文件
function macInit(LUA_PATH,ignore)
    local missFile = {}
    for i,v in ipairs(ignore) do
        missFile[v] = i
    end
    local filename 
    assert(io.open(LUA_PATH),"LUA_PATH is empty!")
    luaFileTable = io.popen('find * ' .. LUA_PATH)
    for file in luaFileTable:lines() do 
        if string.find(file,"%.lua$") then
            filename = luautil.strippath(file)
            if filename ~= nil then
                if missFile[filename] ==  nil then 
                    os.remove(file) print("remove old lua successfully  -->  ",file)
                end
            end
        end
    end
end
function winInit(LUA_PATH)
    luaFileTable = io.popen("cd "..LUA_PATH.." && dir /b /s /a:-D")
    -- luaFileTable = io.popen("dir E:/data/work/muse-tools/excelToLua/lua /b /s")
    for file in luaFileTable:lines() do 
        if string.find(file,"%.lua$") then
            -- print(file)
            filename = string.match(file, ".+\\([^\\]*%.%w+)$")
            -- print(filename)
            if filename ~= nil then os.remove(file) print("remove old lua successfully  -->  ",file) end
        end
    end
end




