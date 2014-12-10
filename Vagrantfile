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
    echo 'Installing dependencies'
    sudo apt-get -qq update
    sudo apt-get -qq install -y build-essential git-core language-pack-ko python-software-properties libssl-dev
    sudo apt-get -qq -y autoremove

    # Set timezone to seoul
    echo 'Set timezone to seoul'
    echo 'Asia/Seoul' | sudo tee /etc/timezone
    sudo dpkg-reconfigure -f noninteractive tzdata > /dev/null 2>&1

    # Install mongodb
    # from http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/

    echo 'Installing mongodb-org'
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 > /dev/null 2>&1
    echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
    sudo apt-get -qq update > /dev/null 2>&1
    sudo apt-get -qq -y install mongodb-org > /dev/null 2>&1

    # restore mongodb dump
    echo 'Restoring mongodb dump'
    curl -L https://dl.dropboxusercontent.com/u/55177834/ansim-2014-1.tar.gz | tar xvz
    mongorestore --db ansim_me_development ./dump/ansim_me_development
    rm -rf ./dump/ansim_me_development

    # Install nodejs
    echo 'Installing nodejs'
    sudo apt-add-repository -y ppa:chris-lea/node.js
    sudo apt-get -y update
    sudo apt-get install nodejs -y
    
    # Install rbenv, ruby-install, rbenv-gem-rehash & ruby 2.1.2
    echo 'Installing ruby & rails'
    cd /home/vagrant && git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
    git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
    echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
    source ~/.bash_profile
    rbenv install 2.1.2
    cd /vagrant/ && gem install bundler && bundle install 

    # rails start!
    rails s -d
    PID=$(ps -eo comm,pid | awk '$1 == "ruby" { print $2 }')
    echo 'if you want to stop rails, kill -9 $PID"

  SCRIPT

  config.vm.provision "shell", inline: $script, privileged: false

  # open http://localhost:3030 & bring it on!

end
