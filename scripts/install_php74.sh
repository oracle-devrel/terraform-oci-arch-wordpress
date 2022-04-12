#!/bin/bash
#set -x

if [[ $(uname -m | sed 's/^.*\(el[0-9]\+\).*$/\1/') != "aarch64" ]]
then
    echo "Detected non-aarch64 architecture..."
    yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(cat /etc/redhat-release  | sed 's/^[^0-9]*\([0-9]\+\).*$/\1/').noarch.rpm
    echo "epel-release-latest-$(cat /etc/redhat-release  | sed 's/^[^0-9]*\([0-9]\+\).*$/\1/') installed."
    yum -y install https://rpms.remirepo.net/enterprise/remi-release-$(cat /etc/redhat-release  | sed 's/^[^0-9]*\([0-9]\+\).*$/\1/').rpm
    echo "remi-release-$(cat /etc/redhat-release  | sed 's/^[^0-9]*\([0-9]\+\).*$/\1/') installed."
else    
    echo "Detected aarch64 architecture..."
    echo "epel-release-latest-$(cat /etc/redhat-release  | sed 's/^[^0-9]*\([0-9]\+\).*$/\1/') skipped."
    echo "remi-release-$(cat /etc/redhat-release  | sed 's/^[^0-9]*\([0-9]\+\).*$/\1/') skipped."
fi

# Install MySQL Community Edition 8.0
rpm -ivh https://dev.mysql.com/get/mysql80-community-release-$(uname -r | sed 's/^.*\(el[0-9]\+\).*$/\1/')-1.noarch.rpm
yum install -y mysql-shell-${mysql_version} 
mkdir ~${user}/.mysqlsh
cp /usr/share/mysqlsh/prompt/prompt_256pl+aw.json ~${user}/.mysqlsh/prompt.json
echo '{
    "history.autoSave": "true",
    "history.maxSize": "5000"
}' > ~${user}/.mysqlsh/options.json
chown -R ${user} ~${user}/.mysqlsh

echo "MySQL Shell successfully installed !"

if [[ $(uname -r | sed 's/^.*\(el[0-9]\+\).*$/\1/') == "el8" ]]
then    
  if [[ $(uname -m | sed 's/^.*\(el[0-9]\+\).*$/\1/') == "aarch64" ]]
  then
    echo "Detected OL8 + aarch64 ..."
    echo "php:remi-7.4 module enablement skipped."
    dnf -y install oraclelinux-developer-release-el8
    dnf -y module enable php:7.4
    dnf -y install php 
    dnf -y install php-cli 
    dnf -y install php-mysqlnd 
    dnf -y install php-zip 
    dnf -y install php-gd 
    dnf -y install php-mcrypt 
    dnf -y install php-mbstring 
    dnf -y install php-xml 
    dnf -y install php-json 
    dnf -y install php-pecl-zip 
    dnf -y install httpd 
    dnf -y install php-pdo 
    dnf -y install php-fpm 
    dnf -y install php-opcache 
    echo "php with dependencies installed."
  else  
    echo "Detected OL8 + x86_64 ..."
    dnf -y module enable php:remi-7.4
    echo "php:remi-7.4 module enabled."
    dnf -y install php php-cli php-mysqlnd php-zip php-gd php-mcrypt php-mbstring php-xml php-json
    echo "php with dependencies installed."
  fi  
else
  if [[ $(uname -m | sed 's/^.*\(el[0-9]\+\).*$/\1/') == "aarch64" ]]
  then
    echo "Detected OL7 + aarch64 ..."
    echo "php:remi-7.4 module enablement skipped."
    yum -y install php php-cli php-mysqlnd php-zip php-gd php-mcrypt php-mbstring php-xml php-json
    echo "php with dependencies installed."   
  else  
    echo "Detected OL7 + x86_64 ..."
    yum-config-manager --enable remi-php74
    echo "php:remi-7.4 module enabled."
    yum -y install php php-cli php-mysqlnd php-zip php-gd php-mcrypt php-mbstring php-xml php-json
    echo "php with dependencies installed."
  fi
fi

echo "MySQL Shell & PHP successfully installed !"
