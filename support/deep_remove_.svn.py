#coding=utf-8
import os
import sys

#
# 参数1：要进行删除的根目录
#

# 要进行删除的根目录，此目录及其递归子目录下得都进行删除
root_path = sys.argv[1]
# 要删除的文件夹名
remove_name = ".svn"

print root_path
os.chdir(root_path)

os.system("find . | grep \""+remove_name+"\" | xargs rm -R")
