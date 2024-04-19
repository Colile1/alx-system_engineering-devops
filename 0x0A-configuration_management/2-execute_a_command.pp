# Manifest to kill process named 'killmenow'
exec { 'pkill killmenow':
  path => '/usr/bin:/usr/sbin:/bin',
  onlyif => 'pgrep -f killmenow',
  refreshonly => true,
  command  => 'pkill killmenow',
  provider => 'shell',
}
