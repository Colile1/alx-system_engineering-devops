# This Puppet manifest configures the SSH client to use a private key and disable password authentication.

include stdlib

# Remove default identity files
file_line { 'Remove default id_rsa':
  ensure            => absent,
  path              => '/etc/ssh/ssh_config',
  line              => '    IdentityFile ~/.ssh/id_rsa',
  match             => '^    IdentityFile ~/\.ssh/id_rsa$',
  match_for_absence => true,
}

file_line { 'Remove default id_dsa':
  ensure            => absent,
  path              => '/etc/ssh/ssh_config',
  line              => '    IdentityFile ~/.ssh/id_dsa',
  match             => '^    IdentityFile ~/\.ssh/id_dsa$',
  match_for_absence => true,
}

# Remove any existing PasswordAuthentication
file_line { 'Remove existing PasswordAuthentication':
  ensure            => absent,
  path              => '/etc/ssh/ssh_config',
  line              => '    PasswordAuthentication',
  match             => '^    PasswordAuthentication',
  match_for_absence => true,
}

# Add our configuration
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
