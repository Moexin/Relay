#!/bin/bash
echo '正在停止转发'
systemctl stop Relay
systemctl disable Relay
echo '正在删除转发'
rm -f /lib/systemd/system/Relay.service
rm -rf Relay
nft add table ip nat
nft delete table ip nat
echo "" > /var/spool/cron/crontabs/root
export EDITOR="/usr/bin/vim.tiny" ;
crontab -e <<EOF
:wq
EOF
apt-get --purge autoremove nftables -y > /dev/null
echo '转发程序卸载完成，BBRPlus内核保留。'