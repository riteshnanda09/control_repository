# Demonstrates how to set ordering and dependencies.

class profile::tripwire {

  contain tripwire  #TODO: write tripwire module...

  Class['profile::kpbase'] ->
  Class['tripwire']

}
