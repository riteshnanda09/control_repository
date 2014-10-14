# Control Repository Configuration

## For Production

No manual configuration is necesary in the prod and dev environments. The control repository is managed and deployed based on the configuration set in the ca_control_repository.

## For Dev

This document outlines the process of configuring and deploying a dev all-in-one puppet master.

### Install R10k

#### Install r10k dependencies

    yum install -y gcc make git

#### Install R10k on the Puppet Master
    /opt/puppet/bin/gem install r10k

#### Configure R10k on the CA
    cat << EOF > /etc/r10k.yaml
    :cachedir: '/var/cache/r10k'
    
    :sources:
      :puppet:
        remote: 'https://github.corp.ebay.com/rinanda/Control_Repository.git'
        basedir: '/etc/puppetlabs/puppet/environments'
    EOF

## Deploy Puppet environments using R10k

   PATH=$PATH:/usr/local/bin /opt/puppet/bin/r10k deploy environment -pv

## Deploy hiera_eyaml

    /opt/puppet/bin/puppet apply --verbose --modulepath='/etc/puppetlabs/puppet/environments/$environment/modules:/etc/puppetlabs/puppet/environments/$environment/site:/etc/puppetlabs/puppet/environment/$environment/dist:/etc/puppetlabs/puppet/modules:/opt/puppet/share/puppet/modules' -e 'include hiera_eyaml'

Copy the CA eyaml pkcs7 keys to /etc/puppetlabs/puppet/hiera_eyaml

## Configure puppet to use the r10k environment

    cat << 'EOF' | /opt/puppet/bin/puppet apply --verbose
    $puppet_confdir = '/etc/puppetlabs/puppet'

    $modulepath = '/etc/puppetlabs/puppet/environments/$environment/modules:/etc/puppetlabs/puppet/environments/$environment/site:/etc/puppetlabs/puppet/environment/$environment/dist:/etc/puppetlabs/puppet/modules:/opt/puppet/share/puppet/modules'

    ini_setting { 'modulepath_main':
      ensure  => present,
      path    => "${puppet_confdir}/puppet.conf",
      section => 'main',
      setting => 'modulepath',
      value   => $modulepath,
    }

    ini_setting { 'modulepath_master':
      ensure  => present,
      path    => "${puppet_confdir}/puppet.conf",
      section => 'master',
      setting => 'modulepath',
      value   => $modulepath,
      notify  => Service['pe-httpd'],
    }

    ini_setting { 'manifest_master':
      ensure  => present,
      path    => "${puppet_confdir}/puppet.conf",
      section => 'master',
      setting => 'manifest',
      value   => "${puppet_confdir}/environments/\$environment/manifests/site.pp",
      notify  => Service['pe-httpd'],
    }

    ini_setting { 'hiera_config':
      ensure  => present,
      path    => "${puppet_confdir}/puppet.conf",
      section => 'main',
      setting => 'hiera_config',
      value   => "${puppet_confdir}/environments/production/hiera.yaml",
      notify  => Service['pe-httpd'],
    }

    service { 'pe-httpd': }
    EOF
