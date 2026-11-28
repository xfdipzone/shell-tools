#!/bin/bash

set -o nounset
set -o errexit

# 解压阿里云导出的数据库 zip 文件，执行重命名，转 utf8 not bom 编码，删除无用语句等处理
#
# Date:     2017-12-18
# Author:   fdipzone
# Ver:      1.0

# ZIP 文件存放的目录
readonly ZIP_DIR="./zip"

# SQL 文件存放的目录
readonly SQL_DIR="./sql"

# 创建 SQL 输出目录
$(mkdir -p "$SQL_DIR")

# 保存解压后重命名的 sql 文件
sqlfile=()

# 遍历 ZIP_DIR 下所有 zip 文件（约定 ZIP_DIR 下只有一层目录）
for file in $(find "$ZIP_DIR" -maxdepth 1 -name "*.zip" -type f) ; do

    # 获取 ZIP 文件名
    filename=$(basename "$file")

    # 定义解压后重命名的文件名
    tmp_sqlfile=$(echo $filename|sed 's/_[0-9]*_all_sql.zip/.sql/')

    # SQL 文件
    output_sqlfile="$SQL_DIR/$tmp_sqlfile"

    # 保存到数组
    sqlfile+=("$output_sqlfile")

    # 执行解压（约定 ZIP 内只有一个文件）
    unzip_file=$(unzip $file|grep 'inflating'|awk -F ' ' '{print $2}'|head -n 1)

    # 重命名
    $(mv $unzip_file $output_sqlfile)

done

# 遍历所有 sql 文件，删除无用语句，且转为 utf8 not bom 编码
for f in "${sqlfile[*]}"; do

    # 删除 ROW_FORMAT=XXX
    $(sed -i 's/ROW_FORMAT=[A-Z]*//g' $f)

    # 删除 AUTO_INCREMENT=XXX
    $(sed -i 's/AUTO_INCREMENT=[0-9]*//g' $f)

    # 删除 utf8 bom
    $(sed -i 's/^\xEF\xBB\xBF//g' $f)

done

exit 0
