import "classes/*.pp"
$site_domain = "budget.local"
$mysql_password = "root"
$mysql_database = "vagrant"

group { "puppet":
  ensure => "present",
}


exec { "apt-update":
    command => "/usr/bin/apt-get update"
}
Exec["apt-update"] -> Package <| |>

File { owner => 0, group => 0, mode => 0644 }

file { '/etc/motd':
  source => "/vagrant/puppet/manifests/files/motd.txt"
}
file { '/home/vagrant/.bash_profile':
  source => "/vagrant/puppet/manifests/files/bash_profile.txt"
}

package { 'vim': ensure => present }
package { 'git-core': ensure => present }
package { 'rubygems': ensure => present }
package { 'unzip': ensure => present }
package { 'curl' : ensure => present }

include apache
include mysql::server
include drupal
include pear
include xdebug
include xhprof
include postfix
include php

# Install the site.
apache::site { $site_domain:
  # documentroot => "site"
}


file { '/var/www/${site_domain}':
  owner => 'vagrant',
  group => 'www-data',
  mode => 0777,
  recurse => true,
}
