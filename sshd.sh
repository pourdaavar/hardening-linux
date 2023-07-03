#!/bin/bash

# Define backup directory
BAC_DIR=/opt/backup/files_$NOW
PASSOWRD_AUTHENTICATION=no

# Check if backup directory exists, create it if it doesn't
if [ ! -d "$BAC_DIR" ]; then
  mkdir -p $BAC_DIR
fi

# Define SSH port
SSH_PORT=22

# Backup sshd_config file
cp /etc/ssh/sshd_config $BAC_DIR

# Modify sshd_config file
cat <<EOT > /etc/ssh/sshd_config
Port $SSH_PORT
ListenAddress 0.0.0.0

# Logging
LogLevel VERBOSE

# Authentication:
#LoginGraceTime 2m
PermitRootLogin yes
#PermitRootLogin without-password
#StrictModes yes
MaxAuthTries 3
MaxSessions 2
#PubkeyAuthentication yes

# To disable tunneled clear text passwords, change to no here!
PasswordAuthentication $PASSOWRD_AUTHENTICATION
#PermitEmptyPasswords no

ChallengeResponseAuthentication no

# GSSAPI options
GSSAPIAuthentication no
#GSSAPICleanupCredentials yes
#GSSAPIStrictAcceptorCheck yes
#GSSAPIKeyExchange no

UsePAM yes

AllowAgentForwarding no
AllowTcpForwarding no
#GatewayPorts no
X11Forwarding no
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
PrintMotd no
#PrintLastLog yes
TCPKeepAlive no
#UseLogin no
#PermitUserEnvironment no
Compression no
ClientAliveInterval 10
ClientAliveCountMax 10
UseDNS no

# no default banner path
Banner /etc/issue.net

# Allow client to pass locale environment variables
AcceptEnv LANG LC_*

AllowUsers root 
AllowGroups root
EOT

# Test sshd_config file
sshd -t

# Enable, restart, and check sshd service status
systemctl enable sshd.service 
systemctl restart sshd.service 
if systemctl is-active --quiet sshd; then
    echo -e "\e[1m \e[96m sshd service: \e[30;48;5;82m \e[5mRunning \e[0m"
else
    echo -e "\e[1m \e[96m sshd service: \e[30;48;5;196m \e[5mNot Running \e[0m"
fi
