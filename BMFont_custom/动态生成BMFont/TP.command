#! /bin/bash

CURRENT_DIR=`dirname $0`

# input paths
IMAGE_DIR=$CURRENT_DIR/muse/

# path that game proj use
GAME_IMAGE_PATH=$CURRENT_DIR/

# path of the texture packer command line tool
TP=/usr/local/bin/TexturePacker

# $1: Source Directory where the assets are located
# $2: Output File Name without extension
# $3: RGB Quality factor
# $4: Scale factor
# $5: Max-Size factor
# $6: Texture Type (PNG, PVR.CCZ)
# $7: Texture format
# $8: Optimization level for pngs (0=off, 1=use 8-bit, 2..7=png-opt)
# $9: Restrict sizes
# $10: Choose algorithm
pack_textures() {

    ${TP} --smart-update \
        --texture-format $7 \
        --format BMFont_custom \
        --data "$2"_{n}.fnt\
        --sheet "$2"_{n}.$6 \
        --multipack \
        --max-size $5 \
        --opt "$3" \
        --png-opt-level $8 \
        --size-constraints "$9" \
        --trim \
        --premultiply-alpha \
        $1

}

# do the job
# this method is for create SOME ccz by some folders
# for i in $IMAGE_DIR/*
# do
#     if [ -d $i ] 
#     then
#         spriteSheetName=`basename $i`
#         pack_textures $i/*.png $GAME_IMAGE_PATH/$spriteSheetName 'RGBA8888' 1 2048 'pvr.ccz' "pvr2ccz" "11111112122222223333333344444444"
#     fi
# done

# maybe in used
# --maxrects-heuristics best \
# --enable-rotation \
# --scale $4 \
# --shape-padding 1 \
# --algorithm "$10" \

# this method is for create One ccz by Recursively adds all known files in some folders
spriteSheetName=`basename $IMAGE_DIR`
pack_textures $IMAGE_DIR $GAME_IMAGE_PATH/$spriteSheetName 'RGBA8888' 1 2048 'png' "png" 1 "AnySize" "MaxRects"




