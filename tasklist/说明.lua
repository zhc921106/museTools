--[[
1.需要配置的路径或者变量，可以在config.yaml中配置

2.自定义变量使用，在testFuc.py的run 函数中有使用示例

3.如要添加工具方法，参照__init__.py中添加方法即可

4.UI启动，可双击 tool.sh.command

5.终端启动，执行Python tool.py ,如执行中需要带参数，参加格式 python too.py --sys parma 1 q 
	会执行 1 2 添加的参数会传到config中，参数设置可见 tool.py 34行附近

6.实现了一个简单的弹出框，使用可见warn.py

]]
print("d")
local a = {}
a[1] = 1
a["d"] = 2
for k,v in pairs(a) do 
	print(k,v)
end