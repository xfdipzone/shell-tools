#!/bin/bash

set -o nounset
set -o errexit

# 获取当前文件目录
readonly ROOT=$(cd "$(dirname "$0")"; pwd)

# 引入log_backup.sh
. ${ROOT}/log_backup.sh

# 日志目录
log_path="/tmp/fdipzone/logs"

# 日志备份目录
backup_log_path="/tmp/fdipzone/bak"

# 日志备份过期时间（天）
backup_log_expire=30

# 获取昨天日期，作为备份日志子目录
if [[ $(uname) == "Darwin" ]]; then
    # Mac
    sub_path=$(date -r $(($(date +%s)-86400)) +%Y/%m/%d)
else
    # Linux
    sub_path=$(date -d "@$(($(date +%s)-86400))" +%Y/%m/%d)
fi

# 执行备份，附加昨天日期作为备份子目录，格式 Y/m/d 例:2023/05/24
backup "${log_path}" "${backup_log_path}/${sub_path}"

# 执行清理过期日志备份文件，并删除没有文件的目录
clear_expire "${backup_log_path}" "${backup_log_expire}"

exit 0