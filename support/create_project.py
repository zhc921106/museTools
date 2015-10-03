#coding=utf-8
import os
import time

project_path = "/data/muse/game-02/trunk/musegame"
package_name = "com.musegame.game"
screen_orientation = "landscape" #portrait
shell_path = "~/Documents/quick-3.3/quick/bin/create_project.sh"

command_list = [
	shell_path, 
	" -f ",
	" -p ", package_name,
	" -o ", project_path,
	" -r ", screen_orientation
]
command = ''.join(command_list)

create_ok = False

# 如果文件夹存在，则提示
if os.path.exists(project_path) :
	ok = raw_input("项目已经存在，是否覆盖？(yes/no): ")
	if ok == "yes" :
		print command
		os.system(command)
		create_ok = True
else :
	print command
	os.system(command)
	create_ok = True


print "---------------------------------"
current_time = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(time.time()))
print current_time
if create_ok :
	print "Done ..."
else :
	print "No changes ..."