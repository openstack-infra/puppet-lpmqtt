# == Class: lpmqtt
#
# Full description of class lpmqtt here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class lpmqtt {
  include ::pip

  package {'lpmqtt':
    ensure   => '0.0.1',
    provider => 'pip',
    require  => Class['pip'],
  }
}
