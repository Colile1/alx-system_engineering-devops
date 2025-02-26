#!/usr/bin/env bash
# Create README.md file at the root
cat << 'EOF' > README.md
# 0x17-web_stack_debugging_3

This project contains a Puppet manifest that fixes the Apache 500 error on a WordPress site by correcting file permissions on /var/www/html.
EOF

# Create Puppet manifest file 0-strace_is_your_friend.pp
cat << 'EOF' > 0-strace_is_your_friend.pp
# 0-strace_is_your_friend.pp - Puppet manifest to fix Apache 500 error on WordPress by correcting file permissions

exec { 'fix-wordpress':
  command => '/bin/chown -R www-data:www-data /var/www/html && service apache2 restart',
  path    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
  unless  => 'test "$(stat -c %U /var/www/html)" = "www-data"',
}
EOF

# Ensure files end with a newline
echo >> README.md
echo >> 0-strace_is_your_friend.pp

# Validate the Puppet manifest with puppet-lint (version 2.1.1)
puppet-lint 0-strace_is_your_friend.pp

# Apply the Puppet manifest to fix the Apache 500 error
puppet apply 0-strace_is_your_friend.pp

# Test the Apache response to verify the fix
echo "Testing Apache response headers:"
curl -sI 127.0.0.1:80

echo -e "\nTesting page content for 'ALX':"
curl -s 127.0.0.1:80 | grep ALX
