#!/bin/bash

set -o nounset
set -o errexit

# 解压阿里云导出的数据库zip文件，执行重命名，转utf8 not bom编码，删除无用语句等处理
# 
# Date:     2017-12-18
# Author:   fdipzone
# Ver:      1.0
#

# 保存解压后重命名的sql文件
sqlfile=()

# 遍历当前目录下所有zip文件
for file in $(find . -name "*.zip" -type f) ; do  

    # 定义解压后重命名的文件名
    tmp_sqlfile=$(echo $file|sed 's/_[0-9]*_all_sql.zip/.sql/')
    tmp_sqlfile=${tmp_sqlfile:2}

    # 保存到数组
    sqlfile+=($tmp_sqlfile)

    # 执行解压
    unzip_file=$(unzip $file|grep 'inflating'|awk -F ' ' '{print $2}')

    # 重命名
    $(mv $unzip_file $tmp_sqlfile)

done

# 遍历所有sql文件，删除无用语句，且转为utf8 not bom编码 
for f in ${sqlfile[*]}; do

    # 删除ROW_FORMAT=XXX
    $(sed -i 's/ROW_FORMAT=[A-Z]*//g' $f)

    # 删除AUTO_INCREMENT=XXX
    $(sed -i 's/AUTO_INCREMENT=[0-9]*//g' $f)

    # 删除utf8 bom
    $(sed -i 's/^\xEF\xBB\xBF//g' $f)

done

exit 0
