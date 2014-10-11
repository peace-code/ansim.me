# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "mozo/ansim.me"
  config.vm.network "forwarded_port", guest: 3000, host: 3030
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.name = "ansim.me"
    vb.memory = 512
  end

  $script = <<-SCRIPT

    #! /bin/bash

    # restore mongodb dump
    cd /tmp && curl -LO https://googledrive.com/host/0By0AzcV9f08-MFd3UUtfUFdza00/dump.tar.gz ; true
    tar xvfz dump.tar.gz && rm dump.tar.gz
    mongorestore --db goodclinic_development ./goodclinic_development --drop && rm -rf /tmp/goodclinic_development/ ; true

    # rails start!
    cd /vagrant/ && rails s -d ; true
    PID=$(ps -eo comm,pid | awk '$1 == "ruby" { print $2 }')
    echo 'if you want to stop rails, kill -9 $PID"

  SCRIPT

  config.vm.provision "shell", inline: $script, privileged: false

  # open http://localhost:3030 & bring it on!

end
