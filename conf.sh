#!/bin/bash
sudo su
cd
yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils gcc
wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.22.1-1.el7.ngx.src.rpm
groupadd builder
useradd -g builder builder
rpm -i nginx-1.22.1-1.el7.ngx.src.rpm
wget --no-check-certificate https://www.openssl.org/source/openssl-1.1.1w.tar.gz
tar -xvf openssl-1.1.1w.tar.gz --directory /usr/lib
yum-builddep /root/rpmbuild/SPECS/nginx.spec -y
# Добавляем аргумент --with-openssl=/usr/lib/openssl-1.1.1w в configure
sed -i "s|--with-stream_ssl_preread_module|--with-stream_ssl_preread_module --with-openssl=/usr/lib/openssl-1.1.1w|" /root/rpmbuild/SPECS/nginx.spec
#Установка nginx

yum localinstall -y /root/rpmbuild/RPMS/x86_64/nginx-1.22.1-1.el7.ngx.x86_64.rpm
sed -i '/index  index.html index.htm;/a autoindex on;' /etc/nginx/conf.d/default.conf
systemctl enable --now nginx

# Создание и настройка  репозитория
mkdir /usr/share/nginx/html/repo
cp /root/rpmbuild/RPMS/x86_64/nginx-1.22.1-1.el7.ngx.x86_64.rpm /usr/share/nginx/html/repo/
createrepo /usr/share/nginx/html/repo/
cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF