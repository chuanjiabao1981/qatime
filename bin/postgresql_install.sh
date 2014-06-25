#!/bin/bash
#主要是下载这个脚本，把postgresql的源加入source list
#http://anonscm.debian.org/loggerhead/pkg-postgresql/postgresql-common/trunk/download/head:/apt.postgresql.org.s-20130224224205-px3qyst90b3xp8zj-1/apt.postgresql.org.sh
#详情参见 https://wiki.postgresql.org/wiki/Apt

apt-cache policy postgresql-9.3
apt-get install postgresql-9.3

#数据盘自动挂载
#/dev/xvdb5 /var/lib/postgresql/data ext4 defaults 0 0

##创建目录
/usr/lib/postgresql/9.3/bin/initdb -D db/ --locale=zh_CN.UTF-8
##修改postgresl启动目录
## 命令行 psql 可以进入提示行

#sudo yum install postgresql-devel