#!/usr/bin/env bash
# Script to implement configuration on servers

# Ask for SSH private key path
read -p "Enter the path to your SSH private key: " SSH_KEY

# Define server information
WEB1_IP="54.146.71.207"
WEB2_IP="52.86.222.127"
LB_IP="54.237.119.194"
USER="ubuntu"

# Function to execute a script on a remote server
execute_script() {
    local SERVER_IP=$1
    local SCRIPT_NAME=$2

    echo "Configuring $SERVER_IP..."
    scp -i "$SSH_KEY" -o StrictHostKeyChecking=no "$SCRIPT_NAME" "$USER@$SERVER_IP:/tmp/$SCRIPT_NAME"
    ssh -i "$SSH_KEY" "$USER@$SERVER_IP" "chmod +x /tmp/$SCRIPT_NAME"
    ssh -i "$SSH_KEY" "$USER@$SERVER_IP" "sudo /tmp/$SCRIPT_NAME"
}

# Apply configurations to web servers
for WEB_IP in "$WEB1_IP" "$WEB2_IP"; do
    execute_script "$WEB_IP" "0-custom_http_response_header.sh"
    echo "Applying Puppet manifest on $WEB_IP..."
    scp -i "$SSH_KEY" "2-puppet_custom_http_response_header.pp" "$USER@$WEB_IP:/tmp/2-puppet.pp"
    ssh -i "$SSH_KEY" "$USER@$WEB_IP" "sudo puppet apply /tmp/2-puppet.pp"
done

# Configure load balancer
execute_script "$LB_IP" "1-install_load_balancer.sh"

echo "All configurations applied successfully."
