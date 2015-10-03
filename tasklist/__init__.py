#coding=utf-8
import os
import sys
actions={'keys':[],'values':{}}
def add_action(key,name,callback):
    actions['keys'].append(key)
    actions['values'][key] = {'name':name,'callback':callback}


# 添加自定义函数, 建议自定义函数以action 或 expect 或 什么什么起头
import action_bt_graph
add_action("opentree","打开行为树编辑器",action_bt_graph.run1)
add_action("opengraph","打开地图编辑器",action_bt_graph.run2)
add_action("exellua","将excel配表导出lua",action_bt_graph.run3)

import action_test
add_action("testKey1","导出123d",action_test.run1)
