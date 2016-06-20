#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export PATH


#先取外网ip，根据取得ip获得网卡，然后通过网卡获得mac地址。
MACSTR="LANG=C ifconfig eth0 | awk '/HWaddr/{ print \$5 }' "
MAC=$(eval $MACSTR)
if [ "$MAC" == "" ]; then
	MACSTR="LANG=C ifconfig eth0 | awk '/ether/{ print \$2 }' "
	MAC=$(eval $MACSTR)
fi	
if [ "$MAC" == "" ]; then
	MAC=$(ip link | awk -F ether '{print $2}' | awk NF | awk 'NR==1{print $1}')
fi

#如果自动取不到就要求手动输入
if [ "$MAC" = "" ]; then
echo "无法自动取得mac地址，请手动输入："
read MAC
echo "手动输入的mac地址是$MAC"
fi

#下载安装包
echo "======================================"
echo "开始下载执行文件。。。。"
echo "======================================"
wget -q -O- http://file.idc.wiki/get.php?serverSpeeder | bash -



#取得序列号
echo "======================================"
echo "开始执行安装。。。。"
echo "======================================"

bash serverSpeeder_setup.sh
