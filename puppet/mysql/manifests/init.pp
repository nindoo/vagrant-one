class mysql {
  package { ['mysql-common', 'mysql-client', 'mysql-server']:
    ensure => latest,
    require => Exec['apt-update'],
  }
  
  package { 'php5-mysql':
    ensure => latest,
    require => Package['php5'],
  }

  service { 'mysql':
    enable => true,
    ensure => running,
    require => Package['mysql-server'],
  }

  exec { 'set-root-password':
    subscribe => [Package['mysql-common'], Package['mysql-client'], Package['mysql-server']],
    refreshonly => true,
    unless => 'mysqladmin -uroot -proot',
    command => 'mysqladmin -uroot password root',
    require => [Package['mysql-server'], Package['mysql-client']]
  }
  
  file { '/etc/mysql/my.cnf':
    ensure => present,
    source => 'puppet:///modules/mysql/my.cnf',
    owner => 'root',
    group => 'root',
    mode => 644,
    require => [Package['mysql-server'], Package['mysql-common'], Package['mysql-client']],
    replace => true,
  }
}