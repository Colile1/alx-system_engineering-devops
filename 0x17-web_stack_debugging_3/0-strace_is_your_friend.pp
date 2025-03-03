# This Puppet manifest fixes the 500 error on Apache/WordPress
class fix_wordpress {
  exec { 'debug-wordpress':
    command => 'sed -i "s/display_errors = Off/display_errors = On/" /etc/php5/apache2/php.ini && service apache2 restart',
    path    => ['/bin', '/usr/bin'],
  }
}
include fix_wordpress
