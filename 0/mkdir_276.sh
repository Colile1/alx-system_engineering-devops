#!/usr/bin/env bash
# This script creates all necessary files for the project, including Bash scripts, HAproxy configurations, and a README.md file.

# Create README.md
cat > README.md << 'EOF'
# HTTPS and SSL Configuration Project

This project involves configuring DNS records, HAproxy for SSL termination, and HTTP to HTTPS redirection.

## Files

- `0-world_wide_web`: A Bash script to audit DNS records for specified subdomains.
- `1-haproxy_ssl_termination`: HAproxy configuration for SSL termination.
- `100-redirect_http_to_https`: HAproxy configuration for redirecting HTTP traffic to HTTPS.
- `run_all.sh`: A Bash script to demonstrate the functionality of `0-world_wide_web`.
EOF

# Create the 0-world_wide_web script
cat > 0-world_wide_web << 'EOF'
#!/usr/bin/env bash
# This script audits DNS records for specified subdomains using `dig` and `awk`.

get_subdomain_info() {
    local domain="$1"
    local subdomain="$2"
    local full_name="${subdomain}.${domain}"

    answer=$(dig +nocmd +noall +answer "$full_name" A)
    record_type=$(echo "$answer" | awk '{print $4}')
    destination=$(echo "$answer" | awk '{print $5}')

    echo "The subdomain $subdomain is a $record_type record and points to $destination"
}

if [ $# -lt 1 ]; then
    exit 1
fi

domain="$1"
subdomain="$2"

if [ -z "$subdomain" ]; then
    for sub in www lb-01 web-01 web-02; do
        get_subdomain_info "$domain" "$sub"
    done
else
    get_subdomain_info "$domain" "$subdomain"
fi
EOF

# Make the 0-world_wide_web script executable
chmod +x 0-world_wide_web

# Create the 1-haproxy_ssl_termination configuration file
cat > 1-haproxy_ssl_termination << 'EOF'
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

frontend https_frontend
    bind *:443 ssl crt /etc/letsencrypt/live/www.example.com/fullchain.pem
    mode http
    default_backend web_backend

backend web_backend
    balance roundrobin
    server web-01 54.146.71.207:80 check
    server web-02 52.86.222.127:80 check
EOF

# Create the 100-redirect_http_to_https configuration file
cat > 100-redirect_http_to_https << 'EOF'
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

frontend http_frontend
    bind *:80
    mode http
    redirect scheme https code 301 if !{ ssl_fc }

frontend https_frontend
    bind *:443 ssl crt /etc/letsencrypt/live/www.example.com/fullchain.pem
    mode http
    default_backend web_backend

backend web_backend
    balance roundrobin
    server web-01 54.146.71.207:80 check
    server web-02 52.86.222.127:80 check
EOF

# Create the run_all.sh script
cat > run_all.sh << 'EOF'
#!/usr/bin/env bash
# This script demonstrates the functionality of the `0-world_wide_web` script.

echo "Running task 0 script..."
./0-world_wide_web holberton.online
echo ""
./0-world_wide_web holberton.online web-02
EOF

# Make the run_all.sh script executable
chmod +x run_all.sh

# Ensure all files end with a newline
for file in README.md 0-world_wide_web 1-haproxy_ssl_termination 100-redirect_http_to_https run_all.sh; do
    sed -i -e '$a\' "$file"
done

echo "All files have been created and made executable."
