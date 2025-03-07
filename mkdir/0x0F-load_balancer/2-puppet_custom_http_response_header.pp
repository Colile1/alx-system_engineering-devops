# Puppet manifest to configure Nginx with a custom HTTP header.
# The header X-Served-By is set to the server's hostname.

class custom_http_header {
  file { '/etc/nginx/conf.d/custom_header.conf':
    ensure  => file,
    content => "add_header X-Served-By ${::hostname};\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  } ->
  Service['nginx'];
}

include custom_http_header

service { 'nginx':
  ensure => running,
  enable => true,
}
