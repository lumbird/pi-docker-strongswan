# Add secrets to /etc/ipsec.secrets
cat << EOF > /etc/ipsec.secrets
: PSK "SHARED_KEY"
EOF