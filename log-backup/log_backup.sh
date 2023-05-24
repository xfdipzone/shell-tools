#!/bin/bash

set -o nounset
set -o errexit

# 备份日志文件，将日志目录文件，备份到日志备份目录
function backup(){
    # 日志目录
    local log_path=$1

    # 日志备份目录
    local backup_log_path=$2

    # 判断日志目录是否存在
    if [[ -d "${log_path}" ]]; then

        # 日志备份目录不存在，执行创建
        if [[ ! -d ${backup_log_path} ]]; then
            mkdir -p ${backup_log_path}
        fi

        # 遍历日志目录文件，复制到日志备份目录（不支持子目录）
        for file in $(find ${log_path} -maxdepth 1 -name "*.log" -type f); do
            copy ${file} ${backup_log_path}
        done

    else
        echo "${log_path} not exists"
    fi
}

# 批量复制文件到指定目录
function copy(){
    # 源文件路径
    local source_file=$1

    # 目标目录
    local dest_path=$2

    # 目标文件路径
    local dest_file="${dest_path}/${source_file##*/}"

    # 源文件存在，且为非0字节文件
    if [[ -f "${source_file}" ]] && [[ -s "${source_file}" ]]; then
        cp "${source_file}" "${dest_file}"
        cat /dev/null > "${source_file}"
        echo "${source_file} copy to ${dest_file} success"
    fi
}

# 清理过期的日志备份文件
function clear_expire(){
    # 日志备份目录
    local backup_log_path=$1

    # 日志备份过期时间（天）
    local backup_log_expire=$2

    if [[ -d ${backup_log_path} ]]; then
        # 如backup_log_expire没有设置，设置默认值
        echo ${backup_log_expire:=30} > /dev/null

        # 删除过期文件
        $(find ${backup_log_path} -name "*.log" -type f -mtime +${backup_log_expire} -exec rm {} \;)

        # 删除空目录 -depth 表示使用深度优先策略，先搜索子目录
        $(find ${backup_log_path} -mindepth 1 -depth -empty -type d -exec rm -r {} \;)
    else
        echo "${backup_log_path} not exists"
    fi
}