#!/usr/bin/env bash
# Master script to configure all servers for the load balancer project

# Ask for SSH private key path
#read -p "Enter the path to your SSH private key: " SSH_KEY

# Define server information
WEB1_IP="54.146.71.207"
WEB2_IP="52.86.222.127"
LB_IP="54.237.119.194"
USER="ubuntu"

# Function to execute a script on a remote server
execute_script() {
    local SERVER_IP=$1
    local SCRIPT_CONTENT=$2
    local SCRIPT_NAME=$3

    echo "Configuring $SERVER_IP..."
    ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no "$USER@$SERVER_IP" "echo '$SCRIPT_CONTENT' > /tmp/$SCRIPT_NAME"
    ssh -i "$SSH_KEY" "$USER@$SERVER_IP" "chmod +x /tmp/$SCRIPT_NAME"
    ssh -i "$SSH_KEY" "$USER@$SERVER_IP" "sudo /tmp/$SCRIPT_NAME"
}

# Define scripts and manifests

## Task 0: Custom HTTP Header on Web Servers
TASK0_SCRIPT=$(cat << 'EOF'
#!/usr/bin/env bash
# Configures Nginx with custom header
apt-get update
apt-get install -y nginx
HOSTNAME=$(hostname)
sed -i "/server_name _;/a \    add_header X-Served-By $HOSTNAME;" /etc/nginx/sites-available/default
nginx -t && systemctl restart nginx
EOF
)

## Task 1: Install Load Balancer
TASK1_SCRIPT=$(cat << 'EOF'
#!/usr/bin/env bash
# Installs and configures HAProxy
apt-get update
apt-get install -y haproxy
cat << 'EOL' > /etc/haproxy/haproxy.cfg
global
    log /dev/log    local0
    log /dev/log    local1 notice
    chroot /var/lib/haproxy
    stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
    stats timeout 30s
    user haproxy
    group haproxy
    daemon

defaults
    log     global
    mode    http
    option  httplog
    option  dontlognull
    timeout connect 5000
    timeout client  50000
    timeout server  50000
    errorfile 400 /etc/haproxy/errors/400.http
    errorfile 403 /etc/haproxy/errors/403.http
    errorfile 408 /etc/haproxy/errors/408.http
    errorfile 500 /etc/haproxy/errors/500.http
    errorfile 502 /etc/haproxy/errors/502.http
    errorfile 503 /etc/haproxy/errors/503.http
    errorfile 504 /etc/haproxy/errors/504.http

frontend http_front
    bind *:80
    stats uri /haproxy?stats
    default_backend webservers

backend webservers
    balance roundrobin
    server web-01 54.146.71.207:80 check
    server web-02 52.86.222.127:80 check
EOL
systemctl enable haproxy
systemctl restart haproxy
EOF
)

## Task 2: Puppet Manifest for Custom Header
TASK2_PUPPET=$(cat << 'EOF'
# Configure Nginx custom header
exec { 'update_apt':
  command => '/usr/bin/apt-get update',
}

package { 'nginx':
  ensure  => installed,
  require => Exec['update_apt'],
}

file { '/etc/nginx/sites-available/default':
  ensure  => present,
  content => "server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;
    add_header X-Served-By \$hostname;
    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;
    location / {
        try_files \$uri \$uri/ =404;
    }
}",
  notify  => Service['nginx'],
  require => Package['nginx'],
}

service { 'nginx':
  ensure  => running,
  enable  => true,
  require => Package['nginx'],
}
EOF
)

# Apply configurations to web servers
for WEB_IP in "$WEB1_IP" "$WEB2_IP"; do
    execute_script "$WEB_IP" "$TASK0_SCRIPT" "0-custom_http_response_header.sh"
    echo "Applying Puppet manifest on $WEB_IP..."
    ssh -i "$SSH_KEY" "$USER@$WEB_IP" "echo '$TASK2_PUPPET' > /tmp/2-puppet.pp"
    ssh -i "$SSH_KEY" "$USER@$WEB_IP" "sudo puppet apply /tmp/2-puppet.pp"
done

# Configure load balancer
execute_script "$LB_IP" "$TASK1_SCRIPT" "1-install_load_balancer.sh"

echo "All configurations applied successfully."
