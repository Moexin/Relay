#!/bin/bash
echo '正在设置时区'
dpkg-reconfigure tzdata
echo '正在更新系统'
apt-get update -y > /dev/null
apt-get upgrade -y > /dev/null
echo '正在安装依赖'
apt-get --purge autoremove iptables -y > /dev/null
apt-get install cron curl wget vim-tiny nftables -y > /dev/null
echo '正在安装转发'
mkdir /root/Relay
cd /root/Relay
while true;do wget -T 15 -c -q https://cdn.jsdelivr.net/gh/Moexin/Relay/Relay/Relay && break;done
chmod +x /root/Relay/Relay
while true;do wget -T 15 -c -q https://cdn.jsdelivr.net/gh/Moexin/Relay/Relay/Relay.conf && break;done
cat > /lib/systemd/system/Relay.service <<EOF
[Unit]
Description=Relay Service
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/root/Relay/Relay /root/Relay/Relay.conf
LimitNOFILE=100000
Restart=always
RestartSec=60

[Install]
WantedBy=multi-user.target
EOF
echo '正在启动转发'
systemctl daemon-reload
systemctl enable --now Relay
echo '设置定时重启'
echo "30 4 * * * systemctl restart Relay" >> /var/spool/cron/crontabs/root
export EDITOR="/usr/bin/vim.tiny" ;
crontab -e <<EOF
:wq
EOF
echo '转发安装完成'