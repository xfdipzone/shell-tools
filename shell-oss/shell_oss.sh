#!/bin/bash

set -o nounset
set -o errexit

# Shell实现OSS上传，下载，删除功能
# OSS 上传，下载，删除
#
# Date:     2020-05-26
# Author:   fdipzone
# Ver:      1.0

# OSS配置
readonly endpoint="${OSS_ENDPOINT}"
readonly bucket="${OSS_BUCKET}"
readonly access_id="${OSS_ACCESS_ID}"
readonly access_key="${OSS_ACCESS_KEY}"

oss_host="${bucket}.${endpoint}"

# 配置检查
if [[ -z "${endpoint}" || -z "${bucket}" || -z "${access_id}" || -z "${access_key}" ]]; then
    echo 'endpoint or bucket or access_id or access_key is empty'
    exit -1
fi

# 上传/下载/删除 put/get/del
method=$1

# 参数检查
if [[ -z "${method}" ]]; then
    echo 'method is empty'
    exit -1
fi

method=$(echo ${method}| tr 'A-Z' 'a-z')

# 源文件
source=$2

# 目标文件
if [[ "${method}" != "del" ]]; then
    dest=$3
fi

# 上传文件
function put(){
    local source=$1
    local dest=$2

    # 参数检查
    if [[ -z "${source}" || -z "${dest}" ]]; then
        echo 'source or dest is empty'
        exit -1
    fi

    dest_file="/${bucket}/${dest}"
    content_type=$(file -ib ${source} | awk -F ";" '{print $1}')
    date_value=$(LANG=en_GB TZ=GMT date +'%a, %d %b %Y %H:%M:%S GMT')
    sign="PUT\n\n${content_type}\n${date_value}\n${dest_file}"
    signature=$(echo -en ${sign} | openssl sha1 -hmac ${access_key} -binary | base64)
    url="http://${oss_host}/${dest}"

    echo "upload ${source} to ${url}"

    curl -i -q -X PUT -T "${source}" \
        -H "Host: ${oss_host}" \
        -H "Date: ${date_value}" \
        -H "Content-Type: ${content_type}" \
        -H "Authorization: OSS ${access_id}:${signature}" \
        ${url}
}

# 下载文件
function get(){
    local source=$1
    local dest=$2

    # 参数检查
    if [[ -z "${source}" || -z "${dest}" ]]; then
        echo 'source or dest is empty'
        exit -1
    fi

    source_file="/${bucket}/${source}"
    content_type=""
    date_value=$(LANG=en_GB TZ=GMT date +'%a, %d %b %Y %H:%M:%S GMT')
    sign="GET\n\n${content_type}\n${date_value}\n${source_file}"
    signature=$(echo -en ${sign} | openssl sha1 -hmac ${access_key} -binary | base64)
    url="http://${oss_host}/${source}"

    echo "download ${url} to ${dest}"

    curl --create-dirs \
        -H "Host: ${oss_host}" \
        -H "Date: ${date_value}" \
        -H "Content-Type: ${content_type}" \
        -H "Authorization: OSS ${access_id}:${signature}" \
        ${url} -o ${dest}
}

# 删除文件
function del(){
    local source=$1

    # 参数检查
    if [[ -z "${source}" ]]; then
        echo 'source is empty'
        exit -1
    fi

    source_file="/${bucket}/${source}"
    content_type=""
    date_value=$(LANG=en_GB TZ=GMT date +'%a, %d %b %Y %H:%M:%S GMT')
    sign="DELETE\n\n${content_type}\n${date_value}\n${source_file}"
    signature=$(echo -en ${sign} | openssl sha1 -hmac ${access_key} -binary | base64)
    url="http://${oss_host}/${source}"

    echo "delete ${url}"

    curl -i -q -X DELETE "${source}" \
        -H "Host: ${oss_host}" \
        -H "Date: ${date_value}" \
        -H "Content-Type: ${content_type}" \
        -H "Authorization: OSS ${access_id}:${signature}" \
        ${url}
}

# 执行方法
if [[ "${method}" == "put" ]]; then
    put ${source} ${dest}
elif [[ "${method}" == "del" ]]; then
    del ${source}
else
    get ${source} ${dest}
fi

exit 0
