-- LuaProfiler
-- Copyright Kepler Project 2005-2007 (http://www.keplerproject.org/luaprofiler)
-- $Id: summary.lua,v 1.5 2007-08-22 21:05:13 carregal Exp $

-- Function that reads one profile file
local function ReadProfile(file)

	local profile

	-- Check if argument is a file handle or a filename
	if io.type(file) == "file" then
		profile = file

	else
		-- Open profile
		profile = io.open(file)
	end

	-- Table for storing each profile's set of lines
	line_buffer = {}

	-- Get all profile lines
	local i = 1
	for line in profile:lines() do
		line_buffer[i] = line
		i = i + 1
    end

	-- Close file
	profile:close()
	return line_buffer
end

-- Function that creates the summary info
local function CreateSummary(lines, summary)

	local global_time = 0

	-- Note: ignore first line
	for i = 2, table.getn(lines) do
		from = string.match(lines[i], "[^\t]+\t([^\t]+)")
		word = string.match(lines[i], "[^\t]+\t[^\t]+\t([^\t]+)")
		local_time, total_time = string.match(lines[i], "[^\t]+\t[^\t]+\t[^\t]+\t[^\t]+\t[^\t]+\t([^\t]+)\t([^\t]+)")
        if not (local_time and total_time) then return global_time end
        if summary[word] == nil then
			summary[word] = {};
			summary[word]["info"] = {}
			summary[word]["info"]["calls"] = 1
			summary[word]["info"]["total"] = local_time
			summary[word]["info"]["from"] = from
			summary[word]["info"]["func"] = word

		else
			summary[word]["info"]["calls"] = summary[word]["info"]["calls"] + 1
			summary[word]["info"]["total"] = summary[word]["info"]["total"] + local_time;
			end

		global_time = global_time + local_time;
		end

	return global_time
end

local function summarydata(file, verbose)
	-- Global time
	global_t = 0

	-- Summary table
	profile_info = {}

	-- Check file type
	local filename = file
	-- if arg[1] == "-v" or arg[1] == "-V" then
	--   verbose = true
	--   filename = arg[2]
	-- else
	--   filename = arg[1]
	-- end
	if filename then
	  file = io.open(filename)
	else
	  print("Usage")
	  print("-----")
	  print("lua summary.lua [-v] <profile_log>")
	  os.exit()
	end
	if not file then
	  print("File " .. filename .. " does not exist!")
	  os.exit()
	end
	firstline = file:read(11)

	-- File is single profile
	if firstline == "stack_level" then

		-- Single profile
		local lines = ReadProfile(file)
		global_t = CreateSummary(lines, profile_info)

	else

		-- File is list of profiles
		-- Reset position in file
		file:seek("set")

		-- Loop through profiles and create summary table
		for line in file:lines() do

			local profile_lines

			-- Read current profile
			profile_lines = ReadProfile(line)

			-- Build a table with profile info
			global_t = global_t + CreateSummary(profile_lines, profile_info)
			end

		file:close()
		end

	-- Sort table by total time
	sorted = {}
	for k, v in pairs(profile_info) do table.insert(sorted, v) end
	table.sort(sorted, function (a, b) return tonumber(a["info"]["total"]) > tonumber(b["info"]["total"]) end)
	return sorted
end

local function WriteProfile(sorted, oupputfile, verbose)
	
	local profile = nil

	-- Check if argument is a file handle or a filename
	if io.type(file) == "file" then
		profile = oupputfile

	else
		-- Open profile
		profile = io.open(oupputfile, "w")
	end
	-- Output summary
	if verbose then
	  profile:write("Node name\tFrom\tCalls\tAverage per call\tTotal time\t%Time\n")
	else
	  profile:write("Node name\tFrom\tTotal time\n")
	end
	for k, v in pairs(sorted) do
		if v["info"]["func"] ~= "(null)" then
			local average = v["info"]["total"] / v["info"]["calls"]
			local percent = 100 * v["info"]["total"] / global_t
			if verbose then
			  profile:write(v["info"]["func"] .. "\t" .. v["info"]["from"].. "\t" .. v["info"]["calls"] .. "\t" .. average .. "\t" .. v["info"]["total"] .. "\t" .. percent .. "\n")
			else
			  profile:write(v["info"]["func"] .. "\t" .. v["info"]["from"].. "\t" .. v["info"]["total"] .. "\n")
			end
		end
	end
	profile:close()
end

--[[--
-   profile - 分析luaprofiler输出文件(out文件)，并将分析结果写入到tofile中
	@param: file - luaprofielr产生的文件路径
	@param: tofile - 分析结果写入文件
	@param: verbose - 需要详细消息
]]
function profile(file, tofile, verbose)
	local sorted = summarydata(file, verbose)
	WriteProfile(sorted, tofile, verbose)
end

--[[--
-   luaprofiler test - luaprofiler使用教程例子
	--luaprofiler test
	local fileUtil = cc.FileUtils:getInstance()
	local wpath = fileUtil:getWritablePath()
	
	--开始和停止(输出文件放在了可写目录下，可以在可写目录下找到相应的文件)
	profiler.start(wpath.."/lprof_%s.out")
	-- profiler.stop()

	--暂停和恢复
	profiler.pause()
	profiler.resume()

	--数据分析的使用
	profile("luaprofiler导出的一个文件", wpath.."summary_output.out", true)
	--调用完该函数后就可以将summary_output.out文件转换成excel文件了
]]
function string.findlast(str, s)
    for i = string.len(str),  1, -1 do
        local tmp = string.sub(str, i, i+#s-1)
        if tmp == s then
            return i
        end
    end
end

-- do_profiler
-- 参数：使用profiler生成的中间文件的路径
-- 结果：在打开xls文件的同时将其生成在参数路径旁边
function do_profiler(...)
	local file = arg[1]
	local dir_end = string.findlast(file, "/")
	local tofile = string.sub(file, 1, dir_end) .. "profile_out.xls"
	profile(file, tofile, true)
	-- 打开生成的xls文件
	os.execute('open ' .. tofile)
end

do_profiler(...)



