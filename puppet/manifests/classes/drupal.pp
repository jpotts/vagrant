class drupal { 
  
  package { [ "libapache2-mod-php5", "php5-mysql", "php5-gd" ]:
    ensure => installed,
    require => [
      Package['python-software-properties'],
      Exec['apt-update-php'],
    ]
  }
  
  # Not sure if there is a way to just require apt-update, and forcing an
  # update. Just requiring doesn't work.
  exec { "apt-update-php":
    command => "/usr/bin/apt-get update",
    require => Exec['add-php-repo'],
  }
  
  exec { "enable-mod-php5":
    command => "/usr/bin/a2enmod php5",
    creates => "/etc/apache2/mods-enabled/php5.conf", 
    require => Package["libapache2-mod-php5"],
    notify => Service["apache2"],
  }
  
  file {'/etc/php5/apache2/conf.d/drupal.ini':
    ensure => present,
    owner => root, group => root, mode => 444,
    content => "post_max_size = 100M \nupload_max_filesize = 100M \nmemory_limit = 196M \nerror_reporting = E_ALL\n",
    notify => Service["apache2"],
  }
  
  file { ["/usr/share/drush", "/usr/share/drush/commands"]:
    ensure => "directory",
  }
  
  exec {'install-registry-rebuild':
    command => "/usr/bin/drush dl registry_rebuild /usr/share/drush/commands/registry_rebuild",
    creates => "/usr/share/drush/commands/registry_rebuild", 
    require => [
      Exec['install-drush'],
      File['/usr/share/drush/commands']
    ]
  }
  
  package { "python-software-properties" :
    ensure => installed,
  }
  
  exec {"add-php-repo":
    command => "/usr/bin/add-apt-repository ppa:rip84/php5",
    require => Package['python-software-properties']
  }

}
