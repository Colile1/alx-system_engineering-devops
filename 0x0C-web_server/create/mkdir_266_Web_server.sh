#!/usr/bin/env bash
# This script sets up the project structure, creates files, installs Shellcheck, and runs Shellcheck tests.

# Create project directory
mkdir -p 0x0C-web_server
cd 0x0C-web_server || exit

# Create README.md
echo "# ALX System Engineering DevOps - Web Server Project" > README.md
echo "This project involves setting up and configuring a web server using Nginx." >> README.md

# Create Task 0: Transfer a file to your server
cat << 'EOF' > 0-transfer_file
#!/usr/bin/env bash
# Transfer a file to a server using scp

if [ "$#" -ne 4 ]; then
    echo "Usage: 0-transfer_file PATH_TO_FILE IP USERNAME PATH_TO_SSH_KEY"
    exit 1
fi

FILE_PATH=$1
IP=$2
USERNAME=$3
SSH_KEY=$4

scp -o StrictHostKeyChecking=no -i "$SSH_KEY" "$FILE_PATH" "$USERNAME@$IP":~
EOF

# Create Task 1: Install Nginx web server
cat << 'EOF' > 1-install_nginx_web_server
#!/usr/bin/env bash
# Install and configure Nginx web server

apt-get -y update
apt-get -y install nginx
echo 'Hello World!' > /var/www/html/index.html
service nginx restart
EOF

# Create Task 2: Setup a domain name
echo "yourdomain.tech" > 2-setup_a_domain_name

# Create Task 3: Redirection
cat << 'EOF' > 3-redirection
#!/usr/bin/env bash
# Configure Nginx to redirect /redirect_me to another page

if ! dpkg -l | grep -q nginx; then
    apt-get -y update
    apt-get -y install nginx
fi

echo '
location /redirect_me {
    return 301 https://www.youtube.com/watch?v=QH2-TGUlwu4;
}
' > /etc/nginx/sites-available/default

service nginx restart
EOF

# Create Task 4: Not found page 404
cat << 'EOF' > 4-not_found_page_404
#!/usr/bin/env bash
# Configure Nginx to serve a custom 404 page

if ! dpkg -l | grep -q nginx; then
    apt-get -y update
    apt-get -y install nginx
fi

echo 'Ceci n'\''est pas une page' > /var/www/html/404.html

sed -i 's|error_page 404 /404.html;|error_page 404 /404.html;\n    location /404.html {\n        root /var/www/html;\n    }|g' /etc/nginx/sites-available/default

sed -i 's|try_files \$uri \$uri/ =404;|try_files \$uri \$uri/ =404 /404.html;|g' /etc/nginx/sites-available/default

service nginx restart
EOF

# Create Task 5: Install Nginx web server with Puppet
mkdir -p templates/nginx
cat << 'EOF' > 7-puppet_install_nginx_web_server.pp
# Install and configure Nginx web server

class nginx_setup {
    package { 'nginx':
        ensure => installed,
    }

    file { '/var/www/html/index.html':
        content => 'Hello World!',
    }

    file { '/etc/nginx/sites-available/default':
        content => template('nginx/default.erb'),
        notify  => Service['nginx'],
    }

    service { 'nginx':
        ensure    => running,
        enable    => true,
        subscribe => [Package['nginx'], File['/etc/nginx/sites-available/default']],
    }
}

# Template: templates/nginx/default.erb
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location /redirect_me {
        return 301 https://www.youtube.com/watch?v=QH2-TGUlwu4;
    }
}
EOF

# Create Puppet template
cat << 'EOF' > templates/nginx/default.erb
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location /redirect_me {
        return 301 https://www.youtube.com/watch?v=QH2-TGUlwu4;
    }
}
EOF

# Make all scripts executable
chmod +x 0-transfer_file 1-install_nginx_web_server 3-redirection 4-not_found_page_404

# Check if Shellcheck is installed, if not, install it
if ! command -v shellcheck &> /dev/null; then
    echo "Shellcheck is not installed. Installing..."
    apt-get -y update
    apt-get -y install shellcheck
fi

# Run Shellcheck on relevant files
echo "Running Shellcheck on Bash scripts..."
shellcheck 0-transfer_file 1-install_nginx_web_server 3-redirection 4-not_found_page_404

echo "Project setup complete!"
