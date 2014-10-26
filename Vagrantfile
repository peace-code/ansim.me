# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/trusty32"
  config.vm.network "forwarded_port", guest: 3000, host: 3000
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

    # Install build tools and korean language pack
    sudo apt-get -qq install -y build-essential git-core language-pack-ko python-software-properties > /dev/null 2>&1
    sudo apt-get -qq -y autoremove > /dev/null 2>&1

    # Set timezone to seoul
    echo 'Asia/Seoul' | sudo tee /etc/timezone
    sudo dpkg-reconfigure -f noninteractive tzdata > /dev/null 2>&1

    # Install mongodb
    # from http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/

    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 > /dev/null 2>&1
    echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
    sudo apt-get -qq update > /dev/null 2>&1
    sudo apt-get -qq -y install mongodb-org > /dev/null 2>&1

    # restore mongodb dump
    curl -L https://doc-0c-30-docs.googleusercontent.com/docs/securesc/ha0ro937gcuc7l7deffksulhg5h7mbp1/u5par7fcic5cv4cshvp4e7fu6t157hkm/1414281600000/09194925479248021352/\*/0B8WezMmea38UWlhNS1lyblk0bHc\?e\=download | tar xvz
    mongorestore --db ansim_me_development ./dump/ansim_me_development
    rm -rf ./dump/ansim_me_development

    # Install nodejs & rbenv & ruby 2.1.2
    sudo apt-add-repository -y ppa:chris-lea/node.js
    sudo apt-get -y update
    sudo apt-get install nodejs

    # rails start!
    cd /vagrant/ && rails s -d
    PID=$(ps -eo comm,pid | awk '$1 == "ruby" { print $2 }')
    echo 'if you want to stop rails, kill -9 $PID"

  SCRIPT

  config.vm.provision "shell", inline: $script, privileged: false

  # open http://localhost:3030 & bring it on!

end
