#! /bin/bash

# Cut the nginx log and backup the nginx log
# $1:the accesst log name
# $2:the post log name
# Author: CJJ
# Website:

save_days=30
log_size=0
max_size=10240
log_home="/home/wwwlogs"
access_log="${log_home}/access.log"
access_backup="${log_home}/access-`date +%Y%m%d`.log"
nginx_pid="/usr/local/nginx/logs/nginx.pid"
log_files=(web web_post)

if [[ -n $1 ]]; then
        # change the nginx log home
        log_home=$1
fi

if [[ -n $2 ]]; then
        # change the pid of nginx
        nginx_pid=$2
fi

if [[ -e ${access_log} ]]; then
        log_size=$(du -k ${access_log} | awk '{print $1}')
        if [[ ${log_size} -ge ${max_size} ]]; then
                mv ${access_log} ${access_backup}
        fi
fi

log_files_num=${#log_files[@]}

for (( i = 0; i < ${log_files_num}; i++ )); do
        mv ${log_home}/${log_files[i]}.log ${log_home}/${log_files[i]}_$(date -d "yesterday" +"%Y%m%d").log
done

# nginx reload the log
kill -USR1 `cat ${nginx_pid}`

#delete 30 days ago nginx log files
find ${log_home} -mtime +${save_days} -exec rm -rf {} \;


