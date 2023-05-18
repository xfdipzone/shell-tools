#!/bin/bash

set -o nounset
set -o errexit

# 终端文本高亮输出
# 可以设置终端文本的文字颜色，背景颜色，粗体，下划线
#
# Date:     2023-05-18
# Author:   fdipzone
# Ver:      1.0

function highlight(){

    # 正常样式
    local normal=$(tput sgr0)

    # 获取配置参数
    local LONGOPTS="str:,color:,bgcolor:,bold:,underline:"
    local ARGS=$(getopt -o nothing --long $LONGOPTS -- "$@")

    # 检查是否有错误
    if [ $? -ne 0 ]; then
        exit 1
    fi

    # 将参数转换为数组
    eval set -- "$ARGS"

    # 遍历参数数组
    while true; do
        case "$1" in
            --str)
                str="$2"
                shift 2
                ;;
            --color)
                color="$2"
                shift 2
                ;;
            --bgcolor)
                bgcolor="$2"
                shift 2
                ;;
            --bold)
                bold="$2"
                shift 2
                ;;
            --underline)
                underline="$2"
                shift 2
                ;;
            --)
                shift
                break
                ;;
            *)
                echo "unknow option: $1"
                exit 1
                ;;
        esac
    done

    # 设置默认值
    echo ${str:=""} > /dev/null
    echo ${color:=""} > /dev/null
    echo ${bgcolor:=""} > /dev/null
    echo ${bold:=0} > /dev/null
    echo ${underline:=0} > /dev/null

    # 设置文本颜色
    case "$color" in
        0|1|2|3|4|5|6|7)
            set_color=$(tput setaf $color;) ;;
        *)
            set_color="" ;;
    esac

    # 设置背景颜色
    case "$bgcolor" in
        0|1|2|3|4|5|6|7)
            set_bgcolor=$(tput setab $bgcolor;) ;;
        *)
            set_bgcolor="" ;;
    esac

    # 设置粗体
    if [ "$bold" = "1" ]; then
        set_bold=$(tput bold;)
    else
        set_bold=""
    fi

    # 设置下划线
    if [ "$underline" = "1" ]; then
        set_underline=$(tput smul;)
    else
        set_underline=""
    fi

    # 打印文本
    printf "${set_color}${set_bgcolor}${set_bold}${set_underline}${str}${normal}\n"

}
