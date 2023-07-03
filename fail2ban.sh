#!/bin/bash

# Define SSH port
SSH_PORT=22

# Backup original fail2ban configuration file
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Modify sshd configuration in fail2ban
sed -i '/^\[sshd\]/a enabled = true' /etc/fail2ban/jail.local
sed -i 's/port    = ssh/port    = '$SSH_PORT'/g' /etc/fail2ban/jail.local
sed -i 's/port     = ssh/port    = '$SSH_PORT'/g' /etc/fail2ban/jail.local

# Restart fail2ban service and check status
systemctl enable fail2ban.service 
systemctl restart fail2ban.service
if systemctl is-active --quiet fail2ban; then
  echo -e "\e[1m \e[96m fail2ban service: \e[30;48;5;82m \e[5mRunning \e[0m"
else
  echo -e "\e[1m \e[96m fail2ban service: \e[30;48;5;196m \e[5mNot Running \e[0m"
fi
sleep 2
fail2ban-client status
