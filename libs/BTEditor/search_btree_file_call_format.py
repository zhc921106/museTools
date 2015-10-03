#!/usr/bin/python
# # # # # # # # # # # # # # # # # # # # # #
#
#	name:	search_btree_file_call_format.py
#	writer:	Cao_Guoyun
#
#	effect:
# 		Get btree file names in given path,
#		and call the format tool 
#
# # # # # # # # # # # # # # # # # # # # # # 

import os

#origin_dir_path is the path of the 
origin_dir_path = "/data/muse/tools/libs/BTEditor/tmp"
#destination_dir_path_default is the default path when the origin lua title is "new Tree"
#destination_dir_path_selected is the selected path when the origin lua title is not "new Tree"
destination_dir_path_default = "/data/muse/game-01/trunk/musegame/src/app/gameplay/behavior/tree"
destination_dir_path_selected = "/data/muse/game-01/trunk/musegame/src/app/gameplay/behavior/subtree"
#lua tool path
lua_path = "/data/muse/tools/libs/BTEditor/FormatBtree.lua"
#except_file_t is list with excepted file names
except_file_t = ["log.lua"]

def write_item():
	for file_name in os.listdir(origin_dir_path):
		if file_name in except_file_t:
			continue
		item_path = os.path.join(origin_dir_path, file_name)
		item_fix = file_name.split('.')[-1]
		if item_fix != 'lua':
			continue
		if os.path.isfile(item_path):
			file_no_fix = file_name.split(".")
			print item_path
			command = 'lua' + ' ' + lua_path +' '+ item_path + ' ' + destination_dir_path_default + '/' + file_no_fix[0] + '.lua' + ' ' + destination_dir_path_selected + '/' + file_no_fix[0] + '.lua'
			os.system(command)
			
write_item()
