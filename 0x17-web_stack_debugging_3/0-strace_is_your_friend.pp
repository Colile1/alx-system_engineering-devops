# Fixes WordPress file permissions to resolve 500 Internal Server Error
exec { 'fix-wordpress':
  command => 'chown -R www-data:www-data /var/www/html',
  path    => '/bin/',
}
