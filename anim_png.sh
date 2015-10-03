#!/bin/bash
root=$(cd `dirname $0`; pwd)
echo $1
python $root/anim_png.py $1