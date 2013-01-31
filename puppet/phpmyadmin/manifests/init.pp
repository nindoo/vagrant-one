class phpmyadmin {
  package { 'phpmyadmin':
    ensure => latest,
    require => [Package['apache2'],Exec['apt-update']],
  }
  
  exec { 'set-phpmyadmin-password':
    command => 'htpasswd -cb /etc/phpmyadmin/htpasswd.setup root root',
    refreshonly => true,
    subscribe => Package['phpmyadmin'],
  }
  
  file { '/etc/phpmyadmin/config.inc.php':
    ensure => file,
    mode => 644,
    source => 'puppet:///modules/phpmyadmin/config.inc.php',
    require => Package['phpmyadmin'],
  }
  
  file { '/etc/apache2/conf.d/phpmyadmin.conf':
    ensure => 'link',
    target => '/etc/phpmyadmin/apache.conf',
    subscribe => Package['phpmyadmin'],
    notify => Exec['reload-apache2'],
  }
  
  exec { 'gunzip-pmadb':
    command => 'gunzip create_tables.sql',
    cwd => '/usr/share/doc/phpmyadmin/examples',
    creates => '/usr/share/doc/phpmyadmin/examples/create_tables.sql',
    subscribe => Package['phpmyadmin'],
  }
  
  exec { 'import-pmadb':
    command => 'mysql -u root -proot < create_tables.sql',
    cwd => '/usr/share/doc/phpmyadmin/examples',
    refreshonly => true,
    subscribe => Exec['gunzip-pmadb'],
  }
  
  exec { 'rechte-pmadb':
    command => "mysql -u root -proot -e \"GRANT SELECT, INSERT, DELETE, UPDATE ON phpmyadmin.* TO 'phpmyadmin'@'localhost' IDENTIFIED BY 'phpmyadmin';\"",
    refreshonly => true,
    subscribe => Exec['import-pmadb'],
    require => Service['mysql'],
    logoutput => true,
  }
}