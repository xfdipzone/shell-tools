#!/bin/bash

set -o nounset
set -o errexit

# 监控进程，将运行超时的进程终止
#
# Date:     2019-12-30
# Author:   fdipzone
# Ver:      1.0

# 进程运行时间格式化为秒数
function get_etime_seconds(){

	# 参数：运行时间
	local runtime=$1

	# 判断是否含有d (exp:4d06)
	if [[ $runtime =~ "d" ]]; then
		seconds=$(echo $runtime|awk -F 'd' '{print $1*3600*24 + $2*3600}')
		echo $seconds
		return 0
	fi

	# 判断是否含有h (exp:1h40)
	if [[ $runtime =~ "h" ]]; then
		seconds=$(echo $runtime|awk -F 'h' '{print $1*3600 + $2*60}')
		echo $seconds
		return 0
	fi

	# 判断是否含有: (exp:22:38)
	if [[ $runtime =~ ":" ]]; then
		seconds=$(echo $runtime|awk -F ':' '{print $1*60 + $2}')
		echo $seconds
		return 0
	fi

}

# 监控超时的进程关键字
readonly process_config=('mytest.php,120')

# 循环监控进程
for config in ${process_config[*]}; do

	# 获取进程关键字及超时时间
	process=$(echo $config|awk -F ',' '{print $1}')
	expire=$(echo $config|awk -F ',' '{print $2}')

	# 获取进程id
	process_id=$(ps -ef | grep "$process" | grep -v "grep" | awk '{print $1}')

	if [[ ! -z "$process_id" ]]; then

		# 获取进程运行时间
		process_runtime=$(ps -eo pid,etime|grep " $process_id "|awk -F ' ' '{print $2}')

		if [[ -z "$process_runtime" ]]; then

			# 获取进程运行时间
			process_runtime=$(ps -eo pid,etime|grep "$process_id "|awk -F ' ' '{print $2}')

		fi

		# 将进程运行时间转为秒数
		process_runtime_second=$(get_etime_seconds $process_runtime)

		echo "process PID:${process_id} ${process} runtime:${process_runtime} seconds:${process_runtime_second}s"

		# 判断是否超时
		if [[ "$process_runtime_second" -ge "$expire" ]]; then

			echo "kill PID:${process_id} ${process} runtime>=${expire}s"

			# 终止进程
			kill -9 $process_id

		fi

	fi

done

exit 0
