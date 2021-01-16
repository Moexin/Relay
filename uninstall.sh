#!/bin/bash
echo '正在停止转发'
systemctl stop Relay
systemctl disable Relay
echo '清空转发规则'
nft add table ip nat
nft delete table ip nat
echo '正在删除转发'
apt-get --purge autoremove nftables -y > /dev/null
rm -f /lib/systemd/system/Relay.service
rm -rf /root/Relay
echo '删除定时任务'
sed -i '/Relay/d' /var/spool/cron/crontabs/root
export EDITOR="/usr/bin/vim.tiny" ;
crontab -e <<EOF
:wq
EOF
echo '删除优化配置'
sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_retries2/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_slow_start_after_idle/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_fastopen/d' /etc/sysctl.conf
sed -i '/fs.file-max/d' /etc/sysctl.conf
sed -i '/fs.inotify.max_user_instances/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
sed -i '/net.ipv4.route.gc_timeout/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_syn_retries/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_synack_retries/d' /etc/sysctl.conf
sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_timestamps/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_max_orphans/d' /etc/sysctl.conf
sed -i '/forward ipv4/d' /etc/sysctl.conf
sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
echo '正在卸载内核'
apt-get --purge autoremove linux-headers-4.14.129-bbrplus -y > /dev/null
apt-get --purge autoremove linux-image-4.14.129-bbrplus -y > /dev/null
update-grub
echo '重启系统生效'
reboot