# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "CentOS-6.4-x86_64-minimal"
  config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130731.box"
  config.vm.network "private_network", ip: "192.168.4.10"

  config.vm.provider :virtualbox do |vb|
    # This allows symlinks to be created within the /vagrant root directory, 
    # which is something librarian-puppet needs to be able to do. This might
    # be enabled by default depending on what version of VirtualBox is used.
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  end

  # This shell provisioner installs librarian-puppet and runs it to install
  # puppet modules. This has to be done before the puppet provisioning so that
  # the modules are available when puppet tries to parse its manifests.
  config.vm.provision :shell, :path => "shell/librarian-puppet.sh"
  config.vm.provision :shell, :inline => "sudo service iptables stop;sudo chkconfig iptables off"

  # Now run the puppet provisioner. Note that the modules directory is entirely
  # managed by librarian-puppet
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file  = "main.pp"
    puppet.options = "--verbose --graph --graphdir /vagrant/graph"
  end
#Download kibana tar.gz
# this is uggly, need to write a puppet module for kibana4
# https://download.elasticsearch.org/kibana/kibana/kibana-4.0.1-linux-x64.tar.gz
  config.vm.provision :shell, :inline => "if [ ! -f kibana-4.tar.gz ]; then  wget  -q -O kibana-4.tar.gz https://download.elasticsearch.org/kibana/kibana/kibana-4.0.1-linux-x64.tar.gz; fi"
  config.vm.provision :shell, :inline => "if [ ! -d kibana-4.0.1-linux-x64 ]; then tar -xzf kibana-4.tar.gz; fi"
  config.vm.provision :shell, :inline => "kibana-4.0.1-linux-x64/bin/kibana >>kibana.log 2>&1 &"

#Load nessus data into ES
  config.vm.provision :shell, :inline => "cd python-libnessus;cd examples/;python es.py"
end
