#!/bin/bash

set -o nounset
set -o errexit

# 更新CSS文件内引用文件的版本
# 如background:url('images/test.jpg'); 更新为 background:url('images/test.jpg?20191224121212');
#
# Date:     2019-12-24
# Author:   fdipzone
# Ver:      1.0

css_tmpl_path="/tmp/css_tmpl"       # css tmpl path
css_path="/tmp/css"                 # css path
replace_tags=(".png" ".jpg" ".gif") # file type
convertnum=0                        # save convert num
search_child=$1                     # search child

echo ${search_child:=0} > /dev/null

function create(){
    tmplfile=$1
    dfile=$2

    dfolder=${dfile%/*}

    if [ ! -d "$dfolder" ]; then
        mkdir -p $dfolder
    fi

    cp "$tmplfile" "$dfile" #复制tmpl到目标文件

    for tag in ${replace_tags[*]} ; do
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
    if [ -d "$css_tmpl_path" ] && [ -d "$css_path" ]; then

        if [ "$search_child" -eq 0 ]; then
            maxdepth=" -maxdepth 1 "
        else
            maxdepth=""
        fi

        for file in $(find $css_tmpl_path $maxdepth -name "*.css" -type f) ; do
            dfile=${file/$css_tmpl_path/$css_path}
            create $file $dfile
        done

        echo "convert num: $convertnum"

    else
        tolog "$css_tmpl_path or $css_path not exists"
    fi
}

update

exit 0
