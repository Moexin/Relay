#!/bin/bash
echo '正在更新系统'
apt-get update -y > /dev/null
apt-get upgrade -y > /dev/null
echo '正在安装依赖'
apt-get --purge autoremove iptables -y > /dev/null
apt-get install cron curl wget chrony vim-tiny nftables -y > /dev/null
echo '正在安装转发'
while true;do wget -P /root/Relay -T 15 -c -q https://cdn.jsdelivr.net/gh/Moexin/Relay/Relay/Relay && break;done
chmod +x /root/Relay/Relay
while true;do wget -P /root/Relay -T 15 -c -q https://cdn.jsdelivr.net/gh/Moexin/Relay/Relay/Relay.conf && break;done
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
echo '正在设置时区'
timedatectl set-timezone Asia/Shanghai
echo '启动自动校时'
systemctl enable --now chrony
chronyc makestep
echo '设置定时重启'
echo "30 4 * * * systemctl restart Relay" >> /var/spool/cron/crontabs/root
export EDITOR="/usr/bin/vim.tiny";
crontab -e <<EOF
:wq
EOF
echo '正在安装内核'
while true;do wget -T 15 -c -q https://raw.sevencdn.com/Moexin/BBRPlus/master/linux-headers-4.14.129-bbrplus.deb && break;done
dpkg -i linux-headers-4.14.129-bbrplus.deb > /dev/null
rm -f linux-headers-4.14.129-bbrplus.deb
while true;do wget -T 15 -c -q https://raw.sevencdn.com/Moexin/BBRPlus/master/linux-image-4.14.129-bbrplus.deb && break;done
dpkg -i linux-image-4.14.129-bbrplus.deb > /dev/null
rm -f linux-image-4.14.129-bbrplus.deb
echo '优化系统配置'
cat << EOF >> /etc/sysctl.conf
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbrplus
net.ipv4.tcp_retries2 = 8
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_fastopen = 3
fs.file-max = 1000000
fs.inotify.max_user_instances = 8192
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.core.somaxconn = 32768
net.core.netdev_max_backlog = 32768
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_max_orphans = 32768
# forward ipv4
net.ipv4.ip_forward = 1
EOF
sysctl -p > /dev/null
echo '重启系统生效'
reboot