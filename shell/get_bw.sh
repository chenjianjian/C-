#! /bin/bash

rm -rf mgmt_bw.txt

while true;do
    line=$(sar -n DEV 1 1 | grep mgmt | awk '{print $1 " " $5 " " $6}')
    bw=$(echo $line | awk '{print $1 " " $2 " " $3}')
    user_num=$(netstat -ntp | grep qemu | wc -l)
    echo "$bw $user_num" >> mgmt_bw.txt
done
