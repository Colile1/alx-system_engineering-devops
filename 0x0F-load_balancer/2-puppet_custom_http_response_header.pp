# Configure Nginx custom header
exec { 'update_apt':
  command => '/usr/bin/apt-get update',
}

package { 'nginx':
  ensure  => installed,
  require => Exec['update_apt'],
}

file { '/etc/nginx/sites-available/default':
  ensure  => present,
  content => "server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;
    add_header X-Served-By \$hostname;
    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;
    location / {
        try_files \$uri \$uri/ =404;
    }
}",
  notify  => Service['nginx'],
  require => Package['nginx'],
}

service { 'nginx':
  ensure  => running,
  enable  => true,
  require => Package['nginx'],
}
