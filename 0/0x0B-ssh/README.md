# ALX-Project SSH Configuration and Key Management

configuring SSH for secure and passwordless authentication. It includes tasks to use private keys, create SSH key pairs, configure SSH client settings, and manage SSH configurations using Puppet.

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

## Server Information
- **Name**: 530803-web-01
- **Username**: ubuntu
- **IP**: 54.146.71.207
- **State**: pending

## Requirements
- Ubuntu 20.04 LTS
- SSH client and server
- Puppet (for Task 4)

