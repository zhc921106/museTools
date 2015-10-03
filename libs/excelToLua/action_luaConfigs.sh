#!/bin/bash
root=$(cd `dirname $0`; pwd)
echo "\n****************************** 开始将excel导出json ******************************\n"
cd $root"/xlsx2json" && ./bin/mac/bin/node index.js --export && echo "\n****************************** 开始将json导出lua ******************************\n" && cd ../json2lua && lua index.lua && python refresh_static.py