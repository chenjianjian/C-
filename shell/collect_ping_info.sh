#! /bin/sh

pro_sleep=60
ping_cnt=50
ping_file="ping.txt"
ping_addr=

collect_ping()
{
    ping_time=$(date +%Y%m%d%H)
    result=$(sed -n "/${ping_time}/p" ${ping_file})
    if [[ -z ${result} ]]; then
            echo >> $ping_file
            echo "$ping_time" >> $ping_file
    fi

    ping -c ${ping_cnt}  $ping_addr >> ${ping_file}
}

usage_info()
{
#前面必须没有空格，有加‘-’可以加tab键
cat <<-EOF
Usage:
  -a ip_addr
  -s time 
  -c cnt 
EOF
}

#选项最前面加个':'屏蔽返回一个错误信息，可使用自己的错误信息
while getopts "a:s:c:f:h" opt; do
    case $opt in
    a)
        ping_addr=$OPTARG
        ;;
    s)
        pro_sleep=$OPTARG
        ;;
    c)
        ping_cnt=$OPTARG
        ;;
    h)
        usage_info
        exit 1
        ;;
    f)
        ping_file=$OPTARG
        ;;
    *) 
        usage_info 
        exit 1
        ;; 
    esac
done


if [[ -z $ping_addr ]]; then
    echo "You must input '-a xx.xx.xx.xx' that you want to ping."
    exit 1
fi

echo "The collect information file: $ping_file"
echo "ping packets number: $ping_cnt"
echo "The program sleep time: $pro_sleep"
if [[ -e ${ping_file} ]]; then
    rm -rf ${ping_file}
    touch $ping_file
else
    touch $ping_file
fi

while [[ "1" = "1" ]]; do
    #statements
    collect_ping
    sleep $pro_sleep
done