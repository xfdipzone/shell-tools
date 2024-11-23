#!/bin/bash

set -o nounset
set -o errexit

# 获取当前文件目录
readonly ROOT=$(cd "$(dirname "$0")"; pwd)

# 引入 highlight.sh
. ${ROOT}/highlight.sh

# 设置一项
highlight --str "Talk is cheap. Show me the code."
highlight --str "Talk is cheap. Show me the code." --color 2
highlight --str "Talk is cheap. Show me the code." --bgcolor 5
highlight --str "Talk is cheap. Show me the code." --bold 1
highlight --str "Talk is cheap. Show me the code." --underline 1

# 设置二项
highlight --str "Talk is cheap. Show me the code." --color 1 --bgcolor 6
highlight --str "Talk is cheap. Show me the code." --color 2 --bold 1
highlight --str "Talk is cheap. Show me the code." --color 2 --underline 1
highlight --str "Talk is cheap. Show me the code." --bgcolor 5 --bold 1
highlight --str "Talk is cheap. Show me the code." --bgcolor 5 --underline 1
highlight --str "Talk is cheap. Show me the code." --bold 1 --underline 1

# 设置三项
highlight --str "Talk is cheap. Show me the code." --color 1 --bgcolor 6 --bold 1
highlight --str "Talk is cheap. Show me the code." --color 1 --bgcolor 6 --underline 1
highlight --str "Talk is cheap. Show me the code." --color 2 --bold 1 --underline 1
highlight --str "Talk is cheap. Show me the code." --bgcolor 5 --bold 1 --underline 1

# 设置四项
highlight --str "Talk is cheap. Show me the code." --color 1 --bgcolor 6 --bold 1 --underline 1

# 高亮输出文本，不设置背景
highlight --str "Talk is cheap. Show me the code." --color 1 --bold 1
highlight --str "Talk is cheap. Show me the code." --color 2 --underline 1
highlight --str "Talk is cheap. Show me the code." --color 3 --bold 1
highlight --str "Talk is cheap. Show me the code." --color 4 --underline 1
highlight --str "Talk is cheap. Show me the code." --color 5 --bold 1
highlight --str "Talk is cheap. Show me the code." --color 6 --underline 1
highlight --str "Talk is cheap. Show me the code." --color 7 --bold 1

# 高亮输出文本，设置背景
highlight --str "Talk is cheap. Show me the code." --color 0 --bgcolor 7 --underline 1
highlight --str "Talk is cheap. Show me the code." --color 1 --bgcolor 6 --bold 1
highlight --str "Talk is cheap. Show me the code." --color 2 --bgcolor 5 --underline 1
highlight --str "Talk is cheap. Show me the code." --color 3 --bgcolor 4 --bold 1
highlight --str "Talk is cheap. Show me the code." --color 4 --bgcolor 3 --underline 1
highlight --str "Talk is cheap. Show me the code." --color 5 --bgcolor 2 --bold 1
highlight --str "Talk is cheap. Show me the code." --color 6 --bgcolor 1 --underline 1
highlight --str "Talk is cheap. Show me the code." --color 7 --bgcolor 0 --bold 1

exit 0
