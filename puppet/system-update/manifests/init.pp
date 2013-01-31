class system-update {
  group { 'puppet':
    ensure => 'present',
  }

  file { '/etc/apt/sources.list.d':
    ensure => directory,
    mode => 0755,
    owner => root,
    group => 0,
  }

  file { '/etc/apt/apt.conf':
    owner => root,
    group => root,
    mode => 644,
  }
  
  exec { 'apt-update':
    command => '/usr/bin/apt-get -y update',
    refreshonly => true,
    logoutput => true,
    subscribe => [
      File['/etc/apt/sources.list.d'],
      File['/etc/apt/apt.conf']
    ],
    notify => Exec['apt-upgrade']
  }
  
  exec { 'apt-upgrade':
    command => 'apt-get -yf dist-upgrade',
    schedule => daily,
    require => Exec['apt-update'],
    logoutput => true,
    timeout => 0,
  }

  package { ['lsb-release', 'rpcbind', 'nfs-common', 'htop', 'curl', 'virtualbox-guest-additions-iso', 'virtualbox-ose-guest-utils']:
    ensure => latest,
    require => Exec['apt-update'],
  }
  
  exec { 'gem-update':
    command => '/opt/vagrant_ruby/bin/gem update --no-rdoc --no-ri',
    schedule => daily
  }
}