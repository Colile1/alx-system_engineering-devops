#!/bin/bash

# Function to install Ruby using apt (Debian/Ubuntu)
install_ruby_apt() {
    sudo apt update
    sudo apt install -y ruby
}

# Function to install Ruby using yum (RHEL/CentOS)
install_ruby_yum() {
    sudo yum install -y ruby
}

# Function to install Ruby using dnf (Fedora)
install_ruby_dnf() {
    sudo dnf install -y ruby
}

# Check the package manager and install Ruby accordingly
if command -v apt &>/dev/null; then
    echo "Detected Debian/Ubuntu-based system."
    install_ruby_apt
elif command -v yum &>/dev/null; then
    echo "Detected RHEL/CentOS-based system."
    install_ruby_yum
elif command -v dnf &>/dev/null; then
    echo "Detected Fedora-based system."
    install_ruby_dnf
else
    echo "Unsupported or unknown Linux distribution. Please install Ruby manually."
fi
