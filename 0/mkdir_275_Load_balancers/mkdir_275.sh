#!/usr/bin/env bash
# Script to create configuration files for the load balancer project

# Task 0: Custom HTTP Header on Web Servers
cat > 0-custom_http_response_header.sh << 'EOF'
#!/usr/bin/env bash
# Configures Nginx with custom header
apt-get update
apt-get install -y nginx
HOSTNAME=$(hostname)
sed -i "/server_name _;/a \    add_header X-Served-By $HOSTNAME;" /etc/nginx/sites-available/default
nginx -t && systemctl restart nginx
EOF

# Task 1: Install Load Balancer
cat > 1-install_load_balancer.sh << 'EOF'
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

# Task 2: Puppet Manifest for Custom Header
cat > 2-puppet_custom_http_response_header.pp << 'EOF'
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

# Make scripts executable
chmod +x 0-custom_http_response_header.sh
chmod +x 1-install_load_balancer.sh

echo "Configuration files created successfully."
