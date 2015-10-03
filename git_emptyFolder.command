#!/bin/bash

# 将所有空文件夹支持添加到git
cd '/data/muse/game-01/trunk/musegame/src'
find . -type d -empty -exec touch {}/.gitignore \;