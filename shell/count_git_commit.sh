#! /bin/bash

verbose=false
since_time=$(date -I)
until_time=$(date -I)

count_line()
{
	add_lines=0
	remove_lines=0
	
	echo $1 $2
	commit_cnt=$(git rev-list --count --since=$1 --until=$2 HEAD)
	echo $commit_cnt
	if [ "$commit_cnt" -gt 0 ];then
		for ((i = 0; i < $commit_cnt; i++)); do
			next=$(expr $i + 1)
			change=$(git diff --shortstat HEAD~$next HEAD~$i)
			echo $change
			values=$(echo "$change" | tr ',' '\n' | grep -o '[0-9]\+')
			eval $(echo $values | awk '{printf("add=%s; remove=%s", $2, $3)}')
			if [ -n "$add" ];then
				add_lines=$(expr $add_lines + $add);
			fi
			if [ -n "$remove" ];then
				remove_lines=$(expr $remove_lines + $remove);
			fi
		done
	fi
	echo ""
	cat << EOF
add lines:   $add_lines
remove lines:$remove_linesg
EOF
}

while getopts "s:u:v" opt; do
	case $opt in
		s) since_time="$OPTARG"; shift ;;
		u) until_time="$OPTARG"; shift ;;
		v) verbose=true; shift ;;
		*) echo "无效选项"; exit 1 ;;
	esac
done
if [ "$verbose" = true ]; then
	echo "-s YYYY-M-D,eg: -s 2024-1-1,since date"
	echo "-u YYYY-M-D,eg: -s 2024-1-1,until date"
	echo "未传参数，表示今日提交"
	exit 1
fi

count_line $since_time $until_time
