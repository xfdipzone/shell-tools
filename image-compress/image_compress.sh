#!/bin/bash

set -o nounset
set -o errexit

# 批量压缩图片工具
# 检查目录及子目录中图片(`jpg`,`gif`,`png`)，将大于指定值的图片进行压缩处理
#
# Date:     2020-01-03
# Author:   fdipzone
# Ver:      1.0

# 设定
readonly folder_path='/photo' # 图片目录路径

readonly max_size='512k' # 图片大小允许值
readonly max_width=1280  # 图片最大宽度
readonly max_height=1280 # 图片最大高度
readonly quality=85      # 图片质量

# 压缩处理
function compress(){

    # 参数：图片目录
    local path=$1

    if [ -d "$path" ]; then

        for file in $(find "$path" \( -name "*.jpg" -or -name "*.gif" -or -name "*.png" \) -type f -size +"$max_size" ); do

            echo $file

            # 调用imagemagick resize图片
            $(convert -resize "$max_width"x"$max_height" "$file" -quality "$quality" -colorspace sRGB "$file")

        done

    else
        echo "$path not exists"
    fi

}

# 执行压缩处理
compress "$folder_path"

exit 0
