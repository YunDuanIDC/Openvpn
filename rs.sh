#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export PATH

#下载安装包
echo "====================================="
echo "=========云端WEB技术团队出品========="
echo "===========开始下载执行文件=========="
echo "====================================="
wget -q -O- http://file.idc.wiki/get.php?serverSpeeder | bash -



#取得序列号
echo "======================================"
echo "=============开始执行安装============="
echo "======================================"

bash serverSpeeder_setup.sh
