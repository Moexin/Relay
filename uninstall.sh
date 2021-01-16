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
echo '转发卸载完成'