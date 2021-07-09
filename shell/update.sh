!# /bin/bash

sync_deb()
{
    expect -c "
    spawn scp -r root@172.28.79.14:/home/share/chen/New_ESTClient/platform/est_gtk_mscreen/linux/packet/rcos-est-client-3
.3.1.deb .
    expect {
        \"*assword\" {set timeout 300; send \"xieyi2021\r\";}
        \"yes/no\" {send \"yes\r\"; exp_continue;}
    }
    expect eof"
}

update_deb()
{
    rm -rf usr
    dpkg -X rcos-est-client-3.3.1.deb .
    cp -rf usr/* /usr
    echo "Update the debain ok."
}

sync_deb
update_deb
