#这里要注意使用fdisk 要对设备使用而不是分区
#fdisk /dev/xvdb  ##注意这里不是/dev/xvdb1
#把/dev/xvdb 拆分成2个盘一个用于数据库 一个用于