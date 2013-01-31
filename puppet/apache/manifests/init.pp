class apache {
  package { ['apache2', 'apache2.2-common', 'libapache2-mod-auth-mysql', 'libapache2-mod-php5']:
    ensure => latest,
    require => Exec['apt-update'],
  }

  service { 'apache2':
    ensure => running,
    enable => true,
    require => Package['apache2'],
  }
  
  file { '/etc/apache2/sites-available/default':
    ensure => present,
    source => 'puppet:///modules/apache/default.conf',
    owner => 'root',
    group => 'root',
    mode => 644,
    require => [Package['apache2'], Package['php5']],
    replace => true,
    notify => Exec['a2ensite-default'],
  }
  
  file { '/etc/apache2/httpd.conf':
    ensure => present,
    source => 'puppet:///modules/apache/httpd.conf',
    owner => 'root',
    group => 'root',
    mode => 644,
    require => [Package['apache2'], Package['php5']],
    notify => Service['apache2'],
    replace => true,
  }
  
  exec { 'a2ensite-default':
    command => '/usr/sbin/a2ensite default',
    creates => '/etc/apache2/sites-enabled/default',
    notify => Exec['reload-apache2'],
    require => Package['apache2'],
    subscribe => File['/etc/apache2/sites-available/default'],
    refreshonly => true,
  }

  exec { 'a2enmod-rewrite':
    command => '/usr/sbin/a2enmod rewrite',
    creates => '/etc/apache2/mods-enabled/rewrite.load',
    notify => Exec['reload-apache2'],
    require => Package['apache2'],
  }
  
  file { '/vagrant/log/':
    ensure => 'directory',
    require => Package['apache2'],
  }

  exec { 'reload-apache2':
    command => 'service apache2 reload',
    refreshonly => true,
    require => Package['apache2'],
  }

  exec { 'force-reload-apache2':
    command => 'service apache2 force-reload',
    refreshonly => true,
    require => Package['apache2'],
  }
}