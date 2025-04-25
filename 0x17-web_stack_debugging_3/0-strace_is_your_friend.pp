# This Puppet manifest fixes the 500 error on Apache/WordPress by setting correct permissions
class fix_wordpress {
  file { '/var/www/html':
    ensure  => directory,
    owner   => 'www-data',
    group   => 'www-data',
    recurse => true,
  }
}
include fix_wordpress
