#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH 
clear
rm ./"$0";
# Logo 	******************************************************************
CopyrightLogo='
================================================================
                                                          
                         OPENVPN+SQUID一键搭建                      
                         Powered by janch.ydidc.top 2016                                    
                          云端互联信息科技有限公司
                                             by Janch 2016-06-14              
================================================================';
echo "$CopyrightLogo";
# FILES  ******************************************************************
sysctl=sysctl.conf;
sq=squid.conf;
VPNFILE=openvpn.zip;
# VAR 	******************************************************************
IPAddress=`wget http://members.3322.org/dyndns/getip -O - -q ; echo`;
port=80;
vpnport=3389;
curls=transfer.sh;
# VAR 	******************************************************************
echo 
echo "输入个人介绍页域名确认安装，取消安装。"
echo 
echo -n "请输入【janch.top】： "
read PASSWD
key2=$PASSWD
if [[ ${key2%%\ *} == janch.top ]]
    then
        echo 
        echo 准备安装！[本机IP：$IPAddress]
    else
        echo
        echo "安装取消！"
QUXIAO='
=========================================================================

                            OpenVPN-2.3.10 安装取消                             
                         Powered by janch.ydidc.top 2016                     
                           云端互联信息科技有限公司
                              All Rights Reserved                  
                                                                            
==========================================================================';
echo "$QUXIAO";
exit 0;
fi
echo
function InputIPAddress()
{
	if [ "$IPAddress" == '' ]; then
		echo '无法检测您的IP';
		read -p '请输入您的公网IP:' IPAddress;
		[ "$IPAddress" == '' ] && InputIPAddress;
	fi;
	[ "$IPAddress" != '' ] && echo -n '[  OK  ] 您的IP是:' && echo $IPAddress;
	sleep 2
}
echo 
echo "正在清理旧版数据..."
sleep 1
service openvpn stop >/dev/null 2>&1
killall squid >/dev/null 2>&1
rm -rf /etc/openvpn/*
rm -rf /home/openvpn/*
rm -rf /etc/squid/*
rm -rf /passwd
yum -y remove squid openvpn
mkdir /etc/openvpn >/dev/null 2>&1
mkdir /etc/squid >/dev/null 2>&1
mkdir /home/openvpn >/dev/null 2>&1
echo "安装执行命令...（正在后台安装，请耐心等待）"
yum -y install update epel-release curl
echo "正在安装前准备..."
sleep 3
echo "检查并更新软件..."
sleep 3
# OpenVPN Installing ****************************************************************************
echo "配置网络环境..."
sleep 3
iptables -F >/dev/null 2>&1
service iptables save >/dev/null 2>&1
service iptables restart >/dev/null 2>&1
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE >/dev/null 2>&1
iptables -A INPUT -p TCP --dport 3389 -j ACCEPT >/dev/null 2>&1
iptables -A INPUT -p TCP --dport 80 -j ACCEPT >/dev/null 2>&1
iptables -A INPUT -p TCP --dport 22 -j ACCEPT >/dev/null 2>&1
iptables -t nat -A POSTROUTING -j MASQUERADE >/dev/null 2>&1
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT >/dev/null 2>&1
service iptables save
service iptables restart
chkconfig iptables on
setenforce 0
# OpenVPN Installing ****************************************************************************
cd /etc
	    rm -rf ./sysctl.conf
		echo "net.ipv4.ip_forward = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
net.ipv4.tcp_syncookies = 1
net.bridge.bridge-nf-call-ip6tables = 0
net.bridge.bridge-nf-call-iptables = 0
net.bridge.bridge-nf-call-arptables = 0
kernel.msgmnb = 65536
kernel.msgmax = 65536
kernel.shmmax = 68719476736
kernel.shmall = 4294967296
" >./${sysctl}
        chmod 0755 ./${sysctl}
		sysctl -p >/dev/null 2>&1
# OpenVPN Installing ****************************************************************************
echo "正在安装主程序..."
sleep 3
yum -y install squid openssl openssl-devel lzo lzo-devel
yum -y install openvpn zip unzip
# OpenVPN Installing ****************************************************************************
cd /home/
cd /etc/openvpn/
		echo "port 3389
proto tcp
dev tun
ca /etc/openvpn/easy-rsa/2.0/keys/ca.crt
cert /etc/openvpn/easy-rsa/2.0/keys/server.crt
key /etc/openvpn/easy-rsa/2.0/keys/server.key
dh /etc/openvpn/easy-rsa/2.0/keys/dh2048.pem
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 114.114.114.114"
push "dhcp-option DNS 114.114.115.115"
keepalive 5 30
tls-auth /etc/openvpn/easy-rsa/2.0/keys/ta.key 0
comp-lzo
max-clients 50
persist-key
status openvpn-status.log
log-append  openvpn.log
verb 3
;mute 20
auth-user-pass-verify /etc/openvpn/passwd.sh via-env
client-cert-not-required
username-as-common-name
script-security 3 system
" >./server.conf
        chmod 0755 ./server.conf
echo "请稍后..."
sleep 3
echo "密码验证脚本..."
echo
sleep 3
wget https://api.ydidc.top/janch/passwd.sh >/dev/null 2>&1
        chmod 0755 ./passwd.sh
        chmod +x ./passwd.sh
        echo "OpenVPN配置完成"
        sleep 3
wget https://raw.githubusercontent.com/YunDuanIDC/Openvpn/master/2.x.zip >/dev/null 2>&1
cd /etc/squid/ >/dev/null 2>&1
echo "正在启用squid转发..."
sleep 2
echo "acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl myip dst 127.0.0.1
http_access deny !myip
via off
forwarded_for delete
request_header_access X-Forwarded-For deny all
request_header_access user-agent  deny all
reply_header_access X-Forwarded-For deny all
reply_header_access user-agent  deny all
request_header_access Via deny all
request_header_access All allow all
http_port 80
http_access allow  all
access_log /var/log/squid/access.log
visible_hostname LZJ
cache_mgr 2627000659@QQ.COM
" >./${sq}
chmod 0755 ./${sq}
echo 'Squid配置完成'
sleep 3
squid -z >/dev/null 2>&1
service squid restart >/dev/null 2>&1
chkconfig squid on
# OpenVPN Installing ****************************************************************************
echo '开始生成证书...'
sleep 2
cd /home
cd /etc/openvpn
unzip 2.x.zip >/dev/null 2>&1
unzip 2.x >/dev/null 2>&1
cp -R /etc/openvpn/easy-rsa-release-2.x/easy-rsa /etc/openvpn/ 
rm -rf /etc/openvpn/easy-rsa-release-2.x /etc/openvpn/2.x.zip /etc/openvpn/easy-rsa/Windows
sleep 2
cd /etc/openvpn/easy-rsa/2.0
rm -rf /etc/openvpn/easy-rsa/2.0/vars
		echo "修改证书信息..."
		echo
		wget https://api.ydidc.top/janch/vars >/dev/null 2>&1
        chmod 0755 ./vars
        cd /etc/openvpn/easy-rsa/2.0
echo
sleep 2
./clean-all 2>&1
. vars 2>&1
./clean-all  2>&1
sleep 2
echo "正在生成证书颁发机构..."
./build-ca server
echo "证书创建完成 "
sleep 2
clear
tip='
================================================================
                                                                                            
                生成证书提示y/n请输入y，其他地方请回车                                          
                                 五秒后继续安装
                                         
================================================================';
echo "$tip";
sleep 6
echo "正在生成服务器证书..."
./build-key-server server
echo "证书创建完成 "
sleep 3
echo "正在生成客户端证书..."
./build-key user01
echo "证书创建完成 "
sleep 3
echo "正在生成SSL加密证书，这是一个漫长的等待过程..."
sleep 3
./build-dh
echo "正在生成TLS密钥..."
sleep 4
openvpn --genkey --secret /etc/openvpn/easy-rsa/2.0/keys/ta.key
# OpenVPN Installing ****************************************************************************
echo 
echo "正在启动服务..."
sleep 2
service openvpn restart
chkconfig openvpn on
sleep 2
# OpenVPN Installing ****************************************************************************
sleep 3
cd /etc/openvpn
cp /etc/openvpn/easy-rsa/2.0/keys/ca.crt /home/openvpn >/dev/null 2>&1
cp /etc/openvpn/easy-rsa/2.0/keys/ta.key /home/openvpn >/dev/null 2>&1
cd /home/openvpn >/dev/null 2>&1
clear
echo
echo 
echo "正在生成配置文件..."
echo 
sleep 3
echo '# OpenVPN profile based on janch
auth-user-pass
client
comp-lzo
dev             tun
keepalive       5 30
key-direction   1
nobind
ns-cert-type    server
persist-key
remote         127.0.0.1 3389 tcp
setenv          CLIENT_CERT 0
' >tmp.1
sleep 2
echo http-proxy    $IPAddress $port >myip
cat tmp.1 myip>tmp.2
sleep 3
echo 'http-proxy-option EXT1 "GET http://rd.go.10086.cn" 
http-proxy-option EXT1 "POST http://rd.go.10086.cn"
http-proxy-option EXT1 "X-Online-Host: rd.go.10086.cn"
http-proxy-option EXT1 "Host: rd.go.10086.cn"
verb            1
<ca>
' >tmp.3
cat tmp.2 tmp.3>tmp.4
cat tmp.4 ca.crt>tmp.5
echo '</ca>
<tls-auth>' >tmp.6
cat  tmp.5 tmp.6>tmp.7
sleep 2
cat tmp.7 ta.key>tmp.8
sleep 2
echo '</tls-auth>
' >tmp.9
sleep 2
cat tmp.8 tmp.9>janch-top.ovpn
echo "配置文件制作完毕"
echo
sleep 2

echo 
clear
echo 
echo "创建账号"
echo 
echo -n "  输入新账号："
read ADMIN
if [ -z $ADMIN ]
	then
		echo -n "  账号不能为空，请重新输入："
		read ADMIN
			if [ -z $ADMIN ]
				then
					echo  "  输入错误，系统创建默认账号：root"
					ADMIN=root;
				else
					username=root;
			fi
else
	username=root;
fi 
echo -n "  输入新密码："
read VPNPASSWD
if [ -z $VPNPASSWD ]
	then
		echo -n "  密码不能为空，请重新输入："
		read VPNPASSWD
			if [ -z $VPNPASSWD ]
				then
					echo  "  输入错误，系统创建默认密码：root"
					VPNPASSWD=root;
				else
					userpasswd=root;
			fi
else
	userpasswd=root;
fi
echo $ADMIN $VPNPASSWD >/passwd
#echo -n "输入新账号："
#read ADMIN
#echo -n "输入新密码："
#read VPNPASSWD
#echo $ADMIN $VPNPASSWD >/passwd
#echo $ADMIN >00
#echo $VPNPASSWD >11
echo '
================================================================
                                                          
                         OPENVPN+SQUID 搭建成功                     
                         Powered by janch.ydidc.top 2016                                    
                            云端互联信息科技有限公司
                                                 by Janch 2016-06-14             
================================================================' >info.txt
echo 
echo 你的账号：$ADMIN >>info.txt
echo 你的密码：$VPNPASSWD >>info.txt

echo 
sleep 3
cd /home/openvpn
rm -rf ./openvpn.zip
zip -r ${VPNFILE} ./{ca.crt,ta.key,info.txt,janch-top.ovpn} >/dev/null 2>&1
rm -rf ./{ta.key,info.txt,myip,tmp.1,tmp.2,tmp.3,tmp.4,tmp.5,tmp.6,tmp.7,tmp.8,tmp.9,User01.ovpn,ca.crt,user01.{crt,key}}
clear
echo
# OpenVPN Installing ****************************************************************************
echo 
sleep 2
echo '=========================================================================='
curl --upload-file ./${VPNFILE} http://transfer.sh/openvpn.zip >url
echo 
echo -n "配置文件下载链接："
cat url
echo
echo '     配置文件保存在服务器/home/openvpn目录下 '
echo 
echo '=========================================================================='
echo 
echo OpenVPN链接账号：$ADMIN
echo OpenVPN链接密码：$VPNPASSWD
echo 
go='
================================================================
                                                          
                   OPENVPN+SQUID一键搭建    
                   
               Powered by janch.ydidc.top 2016                                    
                 云端互联信息科技有限公司

                五秒后安装锐速破解版（OpenVZ不支持安装）
                    

================================================================';
echo "$go";
sleep 5s
clear
echo
o='
================================================================
                                                          
                      锐速破解版安装（国外服务器加速）
                   
                      请注意OpenVZ不支持安装！切勿安装！
                      
                      锐速破解版 by 云端WEB技术团队 2016      
                              
================================================================';
echo "$o";
echo 
echo "输入y安装，任意键取消。"
echo 
echo -n "请输入y或回车键： "
read PASS1
key1=$PASS1
if [[ ${key1%%\ *} == y ]]
    then
        echo 
        echo 准备安装！
    else
        echo
        echo "安装取消！"
QU='
=========================================================================

                                锐速破解版 安装取消                      
                              欢迎使用OPENVPN服务器                  
                                                                            ';
echo "$QU";
echo -n "              配置文件下载链接："
cat /home/openvpn/url
echo
echo '========================================================================='
exit 0;
fi
echo
echo '请稍后...'
sleep 2s
echo '切换到前台安装，请注意查看信息，出现'
echo '[Running Status] ServerSpeeder is running!'
echo '则表示安装成功'
sleep 5s
clear
cd /home
wget https://api.ydidc.top/janch/rs.sh 
bash rs.sh 
echo
clear
OK='
===========================================================================

                   {云端WEB技术团队出品}锐速破解版 安装操作已完成                      
                              欢迎使用OPENVPN服务器
                              显示下句即成功运行锐速。                  
                    “[Running Status]ServerSpeeder is running”                                     ';
echo "$OK";
echo -n "              配置文件下载链接："
cat /home/openvpn/url
echo
echo '========================================================================='
rm -f /home/rs.sh
exit 0;
