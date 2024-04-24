#!/usr/bin/pup
# Installs a flask
package { 'flask':
  ensure   => '2.1.0',
  provider => 'gem'
}
