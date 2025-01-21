#!/usr/bin/env bash
# Configures Nginx with custom header
apt-get update
apt-get install -y nginx
HOSTNAME=$(hostname)
sed -i "/server_name _;/a \    add_header X-Served-By $HOSTNAME;" /etc/nginx/sites-available/default
nginx -t && systemctl restart nginx
