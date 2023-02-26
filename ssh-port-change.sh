#!/bin/bash
set -e

SSHPORT="65522"
NOW=$(date +"%m_%d_%Y-%H_%M_%S")
SSHCONFIG="/etc/ssh/sshd_config"
SSHBACKUP="/etc/ssh/sshd_config.inst.bckup.${NOW}"

cp $SSHCONFIG $SSHBACKUP

sed -i -e "/Port /c\Port $SSHPORT" $SSHCONFIG

# Restart SSH service
if sshd -t -f $SSHCONFIG; then
    systemctl restart sshd
    echo "The SSH port has been changed to $SSHPORT. Please login using that port to test BEFORE ending this session."
    exit 0
else
    cp $SSHBACKUP $SSHCONFIG
    systemctl restart sshd
    echo "The SSH port has not been changed."
    exit 1
fi

