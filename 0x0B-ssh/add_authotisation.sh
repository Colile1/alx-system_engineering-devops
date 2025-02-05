#!/usr/bin/env bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
cat 0x0B-ssh/3-ssh_public_key >> ~/.ssh/authorized_keys
