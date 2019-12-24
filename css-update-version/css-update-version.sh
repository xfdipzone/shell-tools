#!/bin/bash

set -o nounset
set -o errexit

# 更新CSS文件内引用文件的版本
# 如background:url('images/test.jpg'); 更新为 background:url('images/test.jpg?20191224121212');
#
# Date:     2019-12-24
# Author:   fdipzone
# Ver:      1.0

csstmpl_path="/tmp/csstmpl"        # css tmpl path
css_path="/tmp/css"                # css path
replacetags=(".png" ".jpg" ".gif") # file type
convertnum=0                       # save convert num
search_child=$1                    # search child

echo ${search_child:=0} > /dev/null

function create(){
    tmplfile=$1
    dfile=$2

    dfolder=${dfile%/*}

    if [ ! -d "$dfolder" ]; then
        mkdir -p $dfolder
    fi

    cp "$tmplfile" "$dfile" #复制tmpl到目标文件

    for tag in ${replacetags[*]} ; do
        newtag="$tag?$(date +%Y%m%d%H%M%S)"
        sed -i "s/$tag/$newtag/g" "$dfile" #使用sed -i 替换文件内容
    done

    convertnum=$(($convertnum+1))

    tolog "$tmplfile convert to $dfile success"
}

function tolog(){
    echo $1
}

function update(){
    if [ -d "$csstmpl_path" ] && [ -d "$css_path" ]; then

        if [ "$search_child" -eq 0 ]; then
            maxdepth=" -maxdepth 1 "
        else
            maxdepth=""
        fi

        for file in $(find $csstmpl_path $maxdepth -name "*.css" -type f) ; do
            dfile=${file/$csstmpl_path/$css_path}
            create $file $dfile
        done

        echo "convert num: $convertnum"

    else
        tolog "$csstmpl_path or $css_path not exists"
    fi
}

update

exit 0