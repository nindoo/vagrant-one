class vim {
  package { 'vim':
    ensure => latest,
    require => Exec['apt-update'],
  }
}