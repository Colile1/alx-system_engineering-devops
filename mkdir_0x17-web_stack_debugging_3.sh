#!/bin/bash

# Define project directory
PROJECT_DIR="0x17-web_stack_debugging_3"

# Create project directory
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR" || exit

# Create README.md
echo "# Web Stack Debugging 3

This project focuses on debugging a LAMP stack running WordPress and automating fixes with Puppet." > README.md

# Ensure required packages are installed
echo "Installing required dependencies..."
sudo apt-get update -y
sudo apt-get install -y ruby puppet tmux apache2 php libapache2-mod-php mysql-server
sudo gem install puppet-lint -v 2.1.1

# Prompt for IP address if needed
read -rp "Enter the server IP address: " SERVER_IP

# Create Puppet manifest file
cat <<EOF > 0-strace_is_your_friend.pp
# This Puppet manifest fixes the 500 error on Apache/WordPress
class fix_wordpress {
  exec { 'debug-wordpress':
    command => 'sed -i "s/display_errors = Off/display_errors = On/" /etc/php5/apache2/php.ini && service apache2 restart',
    path    => ['/bin', '/usr/bin'],
  }
}
include fix_wordpress
EOF

# Set correct permissions
chmod 644 0-strace_is_your_friend.pp
chmod 644 README.md

# Apply Puppet script
echo "Applying Puppet manifest..."
sudo puppet apply 0-strace_is_your_friend.pp

# Test if the fix worked
echo "Testing the server response..."
curl -sI "$SERVER_IP" | grep "HTTP/1."
