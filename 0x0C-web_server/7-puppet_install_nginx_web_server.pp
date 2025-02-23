# Puppet manifest to install and configure Nginx with a 301 redirect

# Installing Nginx package
package { 'nginx':
  ensure => installed,
}

# Creating index.html with "Hello World!" content
file { '/var/www/html/index.html':
  content => 'Hello World!',
  mode    => '0644',
  require => Package['nginx'],
}

# Configuring Nginx server block with redirect
file { '/etc/nginx/sites-available/default':
  content => @(END),
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
            return 301  https://www.youtube.com/watch?v=QH2-TGUlwu4 permanent;' /etc/nginx/sites-available/default;
        }
    }
    | END
  require => Package['nginx'],
  notify  => Service['nginx'],
}

service { 'nginx':
  ensure  => running,
  enable  => true,
  require => [Package['nginx'], File['/etc/nginx/sites-available/default'], File['/var/www/html/index.html']],
}
