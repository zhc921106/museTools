#coding=utf-8
import os
def run1(config):
	cur_path = os.getcwd()
	bt_sh = cur_path+"/../libs/BTEditor/run_in_love.sh"
	os.system(bt_sh)
def run2(config):
	cur_path = os.getcwd()
	gra_path = cur_path+"/../libs/layout_graph/debug_mac.sh"
	os.system(gra_path)
def run3(config):
	cur_path = os.getcwd()
	gra_path = cur_path+"/../libs/excelToLua/action_luaConfigs.sh"
	os.system(gra_path)