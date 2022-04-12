#!/bin/bash
#set -x

firewall-cmd --zone=public --permanent --add-port=80/tcp
firewall-cmd --zone=public --permanent --add-port=443/tcp
firewall-cmd --reload

chcon --type httpd_sys_rw_content_t /var/www/html
chcon --type httpd_sys_rw_content_t /var/www/html/*
setsebool -P httpd_can_network_connect_db 1
setsebool -P httpd_ssi_exec=1
setsebool -P httpd_execmem=1
setsebool -P httpd_tmp_exec=1
if [[ $(uname -r | sed 's/^.*\(el[0-9]\+\).*$/\1/') == "el8" ]]
then    
  if [[ $(uname -m | sed 's/^.*\(el[0-9]\+\).*$/\1/') == "aarch64" ]]
  then
  	setenforce 0 # disabling SELinux (otherwise php-fpm service will not start).
  	sed -i.bak 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config # SELinux disabled.
  fi
fi	

echo "Local Security Granted !"
