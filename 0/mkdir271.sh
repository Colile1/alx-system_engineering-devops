#!/usr/bin/env bash
# This script creates all necessary files for the project, including Bash scripts and a README.md file.

# Create README.md
cat > README.md << 'EOF'
# Web Stack Debugging Project

This project involves debugging and fixing issues with Nginx to ensure it listens on port 80.

## Files

- `0-nginx_likes_port_80`: A Bash script to fix Nginx configuration to listen on port 80.
- `1-debugging_made_short`: A shorter version of the fix script (5 lines or less).
EOF

# Create the 0-nginx_likes_port_80 script
cat > 0-nginx_likes_port_80 << 'EOF'
#!/usr/bin/env bash
# This script fixes Nginx configuration to ensure it listens on port 80.

# Stop Nginx if it is running
sudo service nginx stop

# Remove the default Nginx configuration that may be blocking port 80
sudo rm -f /etc/nginx/sites-enabled/default

# Restart Nginx to apply changes
sudo service nginx start
EOF

# Make the 0-nginx_likes_port_80 script executable
chmod +x 0-nginx_likes_port_80

# Create the 1-debugging_made_short script
cat > 1-debugging_made_short << 'EOF'
#!/usr/bin/env bash
# This script fixes Nginx configuration to ensure it listens on port 80 in 5 lines or less.

sudo service nginx stop
sudo rm -f /etc/nginx/sites-enabled/default
sudo service nginx start
EOF

# Make the 1-debugging_made_short script executable
chmod +x 1-debugging_made_short

# Ensure all files end with a newline
for file in README.md 0-nginx_likes_port_80 1-debugging_made_short; do
    sed -i -e '$a\' "$file"
done

echo "All files have been created and made executable."
