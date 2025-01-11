#!/bin/bash

# Create the main project directory
mkdir -p 0x0B-ssh
cd 0x0B-ssh

# Create the README.md file
cat <<EOL > README.md
# SSH Configuration and Key Management

This project focuses on configuring SSH for secure and passwordless authentication. It includes tasks to use private keys, create SSH key pairs, configure SSH client settings, and manage SSH configurations using Puppet.

## Tasks

### 0. Use a private key
- **Description**: Connect to a server using a private key.
- **File**: [0-use_a_private_key](0-use_a_private_key)

### 1. Create an SSH key pair
- **Description**: Generate an RSA key pair with a passphrase.
- **File**: [1-create_ssh_key_pair](1-create_ssh_key_pair)

### 2. Client configuration file
- **Description**: Configure the SSH client to use a private key and disable password authentication.
- **File**: [2-ssh_config](2-ssh_config)

### 3. Let me in!
- **Description**: Add an SSH public key to the server for passwordless authentication.
- **File**: [3-ssh_public_key](3-ssh_public_key)

### 4. Client configuration file (w/ Puppet)
- **Description**: Use Puppet to configure the SSH client for passwordless authentication.
- **File**: [100-puppet_ssh_config.pp](100-puppet_ssh_config.pp)

## Requirements
- Ubuntu 20.04 LTS
- SSH client and server
- Puppet (for Task 4)

EOL

# Create the 0-use_a_private_key script
cat <<EOL > 0-use_a_private_key
#!/bin/bash
# This script connects to a server using a private key.

ssh -i ~/.ssh/school ubuntu@8.8.8.8
EOL

# Make the 0-use_a_private_key script executable
chmod +x 0-use_a_private_key

# Create the 1-create_ssh_key_pair script
cat <<EOL > 1-create_ssh_key_pair
#!/bin/bash
# This script generates an RSA key pair with a passphrase.

ssh-keygen -t rsa -b 4096 -f ~/.ssh/school -N "betty"
EOL

# Make the 1-create_ssh_key_pair script executable
chmod +x 1-create_ssh_key_pair

# Create the 2-ssh_config file
cat <<EOL > 2-ssh_config
# SSH client configuration file

Host *
    IdentityFile ~/.ssh/school
    PasswordAuthentication no
EOL

# Create the 3-ssh_public_key file
cat <<EOL > 3-ssh_public_key
# Add this public key to the server's authorized_keys file

ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNdtrNGtTXe5Tp1EJQop8mOSAuRGLjJ6DW4PqX4wId/Kawz35ESampIqHSOTJmbQ8UlxdJuk0gAXKk3Ncle4safGYqM/VeDK3LN5iAJxf4kcaxNtS3eVxWBE5iF3FbIjOqwxw5Lf5sRa5yXxA8HfWidhbIG5TqKL922hPgsCGABIrXRlfZYeC0FEuPWdr6smOElSVvIXthRWp9cr685KdCI+COxlj1RdVsvIo+zunmLACF9PYdjB2s96Fn0ocD3c5SGLvDOFCyvDojSAOyE70ebIElnskKsDTGwfT4P6jh9OBzTyQEIS2jOaE5RQq4IB4DsMhvbjDSQrP0MdCLgwkN
EOL

# Create the 100-puppet_ssh_config.pp Puppet manifest
cat <<EOL > 100-puppet_ssh_config.pp
# This Puppet manifest configures the SSH client to use a private key and disable password authentication.

file_line { 'Declare identity file':
  ensure => present,
  path   => '/etc/ssh/ssh_config',
  line   => '    IdentityFile ~/.ssh/school',
}

file_line { 'Turn off passwd auth':
  ensure => present,
  path   => '/etc/ssh/ssh_config',
  line   => '    PasswordAuthentication no',
}
EOL

# Output success message
echo "Project setup complete. Files and directories have been created."
