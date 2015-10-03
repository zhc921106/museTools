#coding=utf-8
import os
def run():
	path = "/data/muse/game-01/trunk/musegame/src/app/bootstrap/static"	
	file_path = "/data/muse/game-01/trunk/musegame/src/app/bootstrap/static/init.lua"	
	prefix = "app.bootstrap.static."
	begin = "local component = {\n"
	end = "}\nreturn component"
	print("****************************** 生成static.init ******************************")
	file_handle = open(file_path, 'w')
	file_handle.write(begin)
	for item in os.listdir(path):
		name_list = item.split('.')
		if cmp(name_list[1], 'lua') == 0 and cmp(name_list[0], 'init') != 0:
			print(name_list[0])
			file_handle.write('\t["'+name_list[0]+'"]'+'="'+prefix+name_list[0]+'",\n')
	file_handle.write(end)
run()

