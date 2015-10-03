#encode=UTF-8
# # # # # # # # # # # # # # # # # # # # # #
#
#	name:	refresh_png.py
#	writer:	caoguoyun
#
#	effect:
# 		Get png name in child dir of current dir
#		And wirte it to thire __meta file 
#
# # # # # # # # # # # # # # # # # # # # # # 

import os
import string
import sys

currnt_path = sys.argv[1]
last_fix = '.png'
to_file = '/__meta'

def call():
	path_is_dir(currnt_path)

def write_item(dir_path, file_handle):
	item_list = []
	name_dic = {}

	for item in os.listdir(dir_path):
		item_path = os.path.join(dir_path, item)
		if os.path.isfile(item_path):
			file_post_fix = os.path.splitext(item_path)[1].lower()
			if  file_post_fix != last_fix:
				continue
			
			name_list = item.split('.')
			index = name_list[0]
			name = string.atoi(index)
			name_dic[name] = item
			item_list += [name]

	item_list.sort()
	for i in range(0, len(item_list)):
		name_index = item_list[i]
		name = name_dic[name_index]
		file_handle.write('		\'' + name + '\',\n')

def path_has_png(dir_path):
	print dir_path
	file_path = dir_path + to_file
	file_handle = open(file_path, 'w')
	file_handle.write('return {\n\n	imgs={\n')
	write_item(dir_path, file_handle)
	file_handle.write('\n 	},\n\n 	loops=1,\n 	unitdelay=1/12,\n}')

def path_is_dir(dir_path):
	dir_path_has_png = 0
	for item in os.listdir(dir_path):
		item_path = os.path.join(dir_path, item)
		if os.path.isdir(item_path):
			path_is_dir(item_path)
		elif os.path.isfile(item_path):
			file_post_fix = os.path.splitext(item_path)[1].lower()
			if  file_post_fix == last_fix:
				dir_path_has_png = 1

	if dir_path_has_png == 1:
		path_has_png(dir_path)

call()


