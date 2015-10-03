@echo off
title [excell--json--lua]
echo please press enter to make excel to json to lua
@pause > nul
echo ********** starting excel to json **********
cd xlsx2json && .\bin\node index.js --export && echo ********** starting json to lua ********** && cd ../json2lua && .\bin\lua index.lua
@pause