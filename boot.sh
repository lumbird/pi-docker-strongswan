#! /usr/bin/env bash

#===========
# IPTABLES + FIREWALL
#===========

# Remove UFW rules if present (Alpine doesn't use UFW)
if [ -n "$(which ufw)" ]; then ufw disable; fi
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -F
iptables -Z

# Allow established and related connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow SSH traffic
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow loopback traffic
iptables -A INPUT -i lo -j ACCEPT

# Allow IPsec traffic
iptables -A INPUT -p udp --dport 500 -j ACCEPT
iptables -A INPUT -p udp --dport 4500 -j ACCEPT

# Forward IPsec traffic
iptables -A FORWARD --match policy --pol ipsec --dir in --proto esp -s 10.0.0.0/24 -j ACCEPT
iptables -A FORWARD --match policy --pol ipsec --dir out --proto esp -d 10.0.0.0/24 -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eth0 -m policy --pol ipsec --dir out -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eth0 -j MASQUERADE
iptables -t mangle -A FORWARD --match policy --pol ipsec --dir in -s 10.0.0.0/24 -o eth0 -p tcp -m tcp --tcp-flags SYN,RST SYN -m tcpmss --mss 1361:1536 -j TCPMSS --set-mss 1360

# Drop all other incoming and forwarding traffic
iptables -A INPUT -j DROP
iptables -A FORWARD -j DROP

#===========
# CHANGES TO SYSCTL
#===========

# Enable IP forwarding
sysctl -w net.ipv4.ip_forward=1

# Disable accepting ICMP redirect messages
sysctl -w net.ipv4.conf.all.accept_redirects=0

# Disable sending ICMP redirect messages
sysctl -w net.ipv4.conf.all.send_redirects=0

# Enable Path MTU Discovery (PMTU) for IPv4
sysctl -w net.ipv4.ip_no_pmtu_disc=1


#===========
# BOOT
#===========

rm -rf /var/run/starter.charon.pid
ipsec start --nofork

