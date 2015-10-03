#!/bin/bash
curt=`date "+%Y-%m-%d:%H:%M"`      
curd=`date "+%Y-%m-%d"`            
project_root='/data/muse/game-01/trunk/musegame'
project_name='musegame'
project_tool='/data/muse/tools'
p=$1    


# 资源准备
function preres()
{	
	fpk=$project_tool'/libs/fpk'
	to_path=$project_root'/res/musegame'
	src_path=$project_root'/src'
	
	isEmpty '/src'
	isSrc=$?
	isEmpty '/src-x'
	isSrcX=$?
	if test $isSrc == 2 && test $isSrcX == 3; then
		echo 'src 目录为空,src-x 目录不为空. 认为不合法'
		delsrcx
		moveres $src_path $to_path
	fi
	if test $isSrcX == 0 && test $isSrc == 3; then
		echo 'src-x 目录不存在,src 目录不为空. 认为合法'
		moveres $src_path $to_path
	fi
}
function moveres()
{
	rm -rf $2
	$fpk $1 $2
	cd $project_root
	mv src src-x
	mkdir src
}
function delsrcx()
{
	cd $project_root
	rm -rf src
	mv src-x src
}
#  exit 1 
#  0: 目录不存在
#  1: 是一个文件
#  2：目录为空
#  3：目录不为空
function isEmpty()
{
	# echo $1
	path=$project_root$1
	if test -d $path; then
		if test !  "`ls $path`"; then
			return 2
		else
			return 3
		fi
	else
		if test -f $path; then
			return 1
		else
			return 0
		fi
	fi
}
# ipa_name
# 	ipa包的名字
# ipa_path
# 	ipa包的路径
function ipaDeploy() 
{
	# ipa release
	ipa_name=$curt             
	ipa_path=$project_root'/runtime/ios/'           
	target='musegame_iOS.app'
	mac_path=$project_root'/frameworks/runtime-src/proj.ios_mac'
	cd $mac_path && xcodebuild
	ios_path=$mac_path'/build/Release-iphoneos/'
	xcrun -sdk iphoneos packageapplication -v $ios_path$target -o $ipa_path$ipa_name'.ipa'
} 
function apkDeploy()
{
	# apk debug
	apk_name=$curt
	apk_path=$project_root'/runtime/android/'
	target='musegame-debug.apk'
	cd $project_root
	cocos compile -p android   # -m release
	cd $apk_path
	mv $target $apk_name'.apk'
}

if test ! $p || test $p == "ipa"; then
	p='ipa'
	echo $p' deploy'
	# preres
	# ipaDeploy
	# delsrcx
elif test $p == "apk"; then
	echo $p ' deploy'
	# preres
	# apkDeploy
	# delsrcx
fi



