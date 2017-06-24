# Copyright 2016 Hewlett-Packard Development Company, L.P.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

# == Class: lpmqtt::server
#

class lpmqtt::server (
  $imap_username,
  $imap_hostname,
  $imap_password,
  $mqtt_password,
  $imap_use_ssl = true,
  $imap_folder = 'INBOX',
  $imap_delete_old = false,
  $mqtt_hostname = 'firehose01.openstack.org',
  $topic = 'launchpad',
  $mqtt_username = 'infra',
) {
  file { '/etc/lpmqtt.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    content => template('lpmqtt/lpmqtt.conf.erb')
  }
  file { '/etc/systemd/system/lpmqtt.service':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    content => template('lpmqtt/lpmqtt.service.erb')
  }
  group {'lpmqtt':
    ensure => present,
  }

  user { 'lpmqtt':
    ensure     => present,
    home       => '/home/lpmqtt',
    shell      => '/bin/bash',
    gid        => 'lpmqtt',
    managehome => true,
    require    => Group['lpmqtt'],
  }

  file {'/home/lpmqtt':
    ensure  => directory,
    mode    => '0700',
    owner   => 'lpmqtt',
    group   => 'lpmqtt',
    require => User['lpmqtt'],
  }

  service { 'lpmqtt':
    enable     => true,
    hasrestart => true,
    subscribe  => [
      File['/etc/lpmqtt.conf'],
      Package['lpmqtt'],
    ],
    require    => [
      File['/etc/systemd/system/lpmqtt.service'],
      User['lpmqtt'],
    ],
  }
}
