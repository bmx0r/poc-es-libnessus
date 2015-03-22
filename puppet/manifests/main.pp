# Empty puppet manifest.
# Add config here to use your modules managed by librarian-puppet.
include epel

class { 'python':
    version    => 'system',
    dev        => true,
    virtualenv => true,
    pip        => true,
    gunicorn   => false,
  }

python::pip { 'python-libnessus' :
  pkgname       => 'python-libnessus',
  ensure        => 'present',
 }
python::pip { 'python-unittest2' :
  pkgname       => 'unittest2',
  ensure        => 'present',
 }
python::pip { 'python-six' :
  pkgname       => 'six',
  ensure        => 'present',
 }
python::pip { 'python-traceback2' :
  pkgname       => 'traceback2',
  ensure        => 'present',
 }
python::pip { 'python-urllib3' :
  pkgname       => 'urllib3',
  ensure        => 'present',
 }
 python::pip { 'python-elasticsearch' :
  pkgname       => 'elasticsearch',
  ensure        => '1.4.0',
 }
 # python::pip { 'python-argsparse' :
 #  pkgname       => 'argparse',
 #  ensure        => 'present',
 # }


vcsrepo { '/home/vagrant/python-libnessus':
  ensure   => present,
  provider => git,
  source   => 'https://github.com/bmx0r/python-libnessus.git',
  owner => 'vagrant',
  group =>  'vagrant',
  }

 package {
    'gcc':
      ensure => present;
    'nmap':
      ensure => present;
    'vim-enhanced':
      ensure => present;
    'git':
      ensure => present;
  }
class { 'elasticsearch':
    java_install => true,
    ensure => present,
    manage_repo  => true,
    repo_version => '1.4',
    datadir => '/var/lib/elasticsearch-data'
  }
elasticsearch::instance { 'es-01':
    config => {
            'node' => {
              'name' => $::hostname
                       },
             'index' => {
                         'number_of_replicas' => '0',
                         'number_of_shards'   => '5'
                        },
             'cluster' => {
                           'name' => 'ESClusterName',
                           },
            },
    status   => 'enabled',
  }
  elasticsearch::plugin{'mobz/elasticsearch-head':
    module_dir => 'head',
    instances => ['es-01'],
  }
  elasticsearch::plugin{'karmi/elasticsearch-paramedic':
    module_dir => 'paramedic',
    instances => ['es-01'],
  }

Class['elasticsearch'] -> Class['python']
