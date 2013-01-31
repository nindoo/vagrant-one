Exec {
  path => ['/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/']
}

include system-update
include vim
include php5
include mysql
include apache
include phpmyadmin
include git
include memcached
Exec['apt-update'] -> Package <||>
