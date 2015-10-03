#!/bin/bash
root=$(cd `dirname $0`; pwd)
echo "****************************** 开始将excel导出json ******************************" && cd $root"/libs/excelToLua/xlsx2json" && ./bin/mac/bin/node index.js --export && echo "****************************** 开始将json导出lua ******************************" && cd ../json2lua && lua index.lua && python refresh_static.py