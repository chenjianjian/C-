#! /bin/bash

# Backup mysql database
# $1:If you want to backup other database,input first parameter
# $2:If you want to input other password,input second parameter
# Author: CJJ
# Website:

backup_home="/home/mysql_back"
mysql_dump="/usr/local/mysql/bin/mysqldump"
mysql_user=root
mysql_pass=RGAHppUc4359rPTQ
backup_database=gb8889
cur_time=$(date +%Y%m%d%H%M)
cur_day=$(date +%Y%m%d)
delete_time=$(date -d -7day +"%Y%m%d")

backup_sql()
{
        if [[ ! -d ${backup_home} ]]; then
                mkdir -p ${backup_home}
        fi

        if [[ ! -f ${mysql_dump} ]]; then
                echo "mysqldump command not found,please check your setting."
        exit 1
        fi

        if [[ ! -e ${backup_home}/${cur_day} ]]; then
                mkdir -p ${backup_home}/${cur_day}
        fi

        ${mysql_dump} -u${mysql_user} -p${mysql_pass} ${backup_database} \
            > ${backup_home}/${cur_day}/${backup_database}_${cur_time}.sql
}

rm_oldbackup()
{
        if [[ -z $1 ]]; then
                echo "You must input one param that you want to delete."
                exit 1
        fi

        if [[ -e $1 ]]; then
                rm -rf $1
        fi
}

if [[ -n $1 ]]; then
        # $1 strand for database name
        backup_database=$1
fi

if [[ -n $2 ]]; then
        # $2 strand for database password
        mysql_pass=$2
fi

backup_sql
rm_oldbackup ${backup_home}/${delete_time}

