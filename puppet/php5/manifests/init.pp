class php5 {
  package { 'php5':
    ensure => latest,
    require => Exec['apt-update'],
  }

  package { 'php-pear':
  	ensure => latest,
  	require => Exec['apt-update'],
  }

  exec { 'pear-update':
  	command => 'pear update-channels && pear upgrade-all',
    schedule => daily,
    require => Package['php-pear'],
  }
  
  package { 'php5-xdebug':
  	ensure => latest,
  	require => Exec['apt-update'],
  }
  
  file { '/etc/php5/apache2/conf.d/debug.ini':
    ensure => present,
    source => 'puppet:///modules/php5/debug.ini',
    owner => 'root',
    group => 'root',
    mode => 644,
    require => Package['php5'],
    replace => true,
    notify => Exec['reload-apache2'],
  }
}