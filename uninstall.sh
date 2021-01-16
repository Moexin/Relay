#!/bin/bash
echo -n '正在停止转发'
systemctl stop Relay
systemctl disable Relay
echo -n '清空转发规则'
nft add table ip nat
nft delete table ip nat
echo -n '正在删除转发'
apt-get --purge autoremove nftables -y > /dev/null
rm -f /lib/systemd/system/Relay.service
rm -rf /root/Relay
echo -n '删除定时任务'
sed -i '/Relay/d' /var/spool/cron/crontabs/root
export EDITOR="/usr/bin/vim.tiny" ;
crontab -e <<EOF
:wq
EOF
echo -n '转发卸载完成'