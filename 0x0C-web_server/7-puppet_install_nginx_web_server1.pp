# Install and configure Nginx web server

class nginx_setup {
    package { 'nginx':
        ensure => installed,
    }

    file { '/var/www/html/index.html':
        content => 'Hello World!',
    }

    file { '/etc/nginx/sites-available/default':
        content => template('nginx/default.erb'),
        notify  => Service['nginx'],
    }

    service { 'nginx':
        ensure    => running,
        enable    => true,
        subscribe => [Package['nginx'], File['/etc/nginx/sites-available/default']],
    }
}

# Template: templates/nginx/default.erb
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location /redirect_me {
        return 301 https://www.youtube.com/watch?v=QH2-TGUlwu4;
    }
}
