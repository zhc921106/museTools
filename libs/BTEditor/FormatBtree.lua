
local table_insert = table.insert
local table_concat = table.concat
local string_lower = string.lower
local string_gsub  = string.gsub
local string_sub = string.sub
local string_find = string.find


function string.split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string_find(input, delimiter, pos, true) end do
        table_insert(arr, string_sub(input, pos, st - 1))
        pos = sp + 1
    end
    table_insert(arr, string_sub(input, pos))
    return arr
end

function string.trim(input)
    input = string_gsub(input, "^[ \t\n\r]+", "")
    return string_gsub(input, "[ \t\n\r]+$", "")
end

-- -------------------------------------------------
-- 
-- tools action
-- 
-- --------------------------------------------------

local FormatBtree = {}

-- 写入目标文件对象的前缀
FormatBtree.data_prefix = [[
return function()

local registry = muse.mgr.registry

]]

-- 写入目标文件对象的前缀
FormatBtree.data_postfix = [[

end
]]

-- --------------
-- 
-- 提取有用的table
-- 
-- --------------
function FormatBtree.getChildren(children_t, father_name)
	local tasks = {}
	for index,child in ipairs(children_t) do
		local task = {}
		local isDecorator = false
        local name_o = string.trim(child.name)
        -- 在工具 BTEditor 中, 节点名字不能够以 "." 结尾
        assert(string_sub(name_o, string.len(name_o)) ~= ".", "节点名字不能够以 \".\" 结尾")
        if father_name then
	        isDecorator = string_find(string.lower(father_name), "decorator") ~= nil
	    end
        local name_t = string.split(name_o, ".")
        table_insert(name_t, child.id)
        task.name = string_lower(table.concat(name_t, "_"))
        task.id = child.id

		task.type = name_o
		-- 假如工具中的Func项为空的话，则默认填写name项中的后面两个名字
		if child.func ~= "" then
			local func_o = string.trim(child.func)
			local func_t = string.split(func_o, ";")
			task.log_obj = func_t[1]
			if func_t[2] ~= nil then
				local func = func_t[2]
				task.func_name = string_sub(func, 1, string_find(func, "%(") - 1)
				task.func = func
			end
		else
			local len = #name_t
			local log_obj_t = {name_t[len - 2], name_t[len - 1]}
			task.log_obj = table_concat(log_obj_t, ".")
		end
		if isDecorator == true then
			task.add = "setTask"
		else
			task.add = "addChild"
		end
		if child.children then
			task.children = FormatBtree.getChildren(child.children, name_o)
		end
		table_insert(tasks, task)
	end
	return tasks
end

-- ----------------
-- 
-- 得到主树
-- 
-- ----------------
function FormatBtree.getTree(tree_t)
    return FormatBtree.getChildren(tree_t.children)[1]
end

-- ----------------
-- 
-- 写文件操作
-- 
-- ----------------
function FormatBtree.writeToFile(string, destination_file_path)
	local file = io.open(destination_file_path, "w");
	assert(file);
	file:write(string);
	file:close();
end

-- -----------------------------
-- 
-- 对单个节点进行递归写入处理
-- 
-- ------------------------------
function FormatBtree.getContext_(context_t, data_str, father)
	local context_s_t = {}
	local isAddChild = true
    local father_name = father or context_t.name

	table_insert(context_s_t, "local ")
	table_insert(context_s_t, context_t.name)
    table_insert(context_s_t, " = registry:getClass(\"")
	table_insert(context_s_t, context_t.type)
    table_insert(context_s_t, "\")")
	table_insert(context_s_t, ".new(\"")
	table_insert(context_s_t, context_t.log_obj)
	table_insert(context_s_t, "\")\n")

	if context_t.func_name then
		table_insert(context_s_t, "if type(")
		table_insert(context_s_t, context_t.name)
		table_insert(context_s_t, ".")
		table_insert(context_s_t, context_t.func_name)
		table_insert(context_s_t, ") == \"function\" then\n 	")
		table_insert(context_s_t, context_t.name)
		table_insert(context_s_t, ":")
		table_insert(context_s_t, context_t.func)
		table_insert(context_s_t, "\nend\n")
	end
    -- 假如该节点为根节点则不将该节点添加到父节点
    local root_task = nil
    if father == nil then
        root_task = context_t.name
        isAddChild = false
    end
	if isAddChild == true then
		table_insert(context_s_t, father_name)
		table_insert(context_s_t, ":") 
		table_insert(context_s_t, context_t.add)
		table_insert(context_s_t, "(")
		table_insert(context_s_t, context_t.name)
		table_insert(context_s_t, ")\n\n")
	else
        table_insert(context_s_t, "\n")
    end
	
	data_str = data_str .. table_concat(context_s_t)
	if context_t.children then
		for i=1,#context_t.children do
			data_str = FormatBtree.getContext_(context_t.children[i], data_str, context_t.name)
		end
	end
    
	return data_str, root_task
end

-- Sequence_node1 = {
-- 	type = "Sequence",
-- 	name = "Sequence_node1",
-- 	children = {
-- 		{
-- 			name = "Invoke_node2",
-- 			type = "Invoke",
-- 			func_name = "callback",
-- 			func_param = "print(\"Hello World\")",
-- 		},	
-- 		{
-- 			name = "Empty_node3",
-- 			type = "Empty",
-- 		},
-- 	}	
-- }
-- -----------------------------
-- 
-- 开始序列化
-- 
-- -----------------------------
function FormatBtree.format(root)
	local data_t = {}
	local btree = FormatBtree.getTree(root)
	local context_str = ""
	table_insert(data_t, FormatBtree.data_prefix)

	context_str, root_task = FormatBtree.getContext_(btree, context_str, nil)
	table_insert(data_t, context_str)
    table_insert(data_t, "return ")
    table_insert(data_t, root_task)
    table_insert(data_t, FormatBtree.data_postfix)
	local context = table_concat(data_t)
    
    return context
end

-- -----------------------------
-- 
-- 入口函数
-- 
-- @param:
-- origin_director_path - 编辑器导出的文件所在路径
-- destination_director_path - 将序列化后的文件存放的路径文件夹
-- -----------------------------
function FormatBtree.main(origin_file_path, destination_file_path_default, destination_file_path_selected)
    local btree_file = dofile(origin_file_path)
    local root = btree_file.nodes[1]
    local destination_file_path = nil
    if btree_file.title == "new Tree" then
    	destination_file_path = destination_file_path_default
    else
    	destination_file_path = destination_file_path_selected
    end

    local context = FormatBtree.format(root)
    FormatBtree.writeToFile(context, destination_file_path)
end

FormatBtree.main(...)











