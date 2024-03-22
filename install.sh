#!/bin/sh

# Update system
apk update

# Install StrongSwan and other required packages
apk add strongswan moreutils kmod

#===========
# STRONG SWAN CONFIG
#===========
