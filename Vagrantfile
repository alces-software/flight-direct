# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.box = 'centos/7'
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.define 'master', primary: true do |master|
    master.vm.hostname = 'master'
    master.vm.network "private_network", type: "dhcp"
    master.vm.synced_folder '.', '/tmp/direct'
  end

  config.vm.define 'slave' do |slave|
    slave.vm.hostname = 'slave'
    slave.vm.network "private_network", type: "dhcp"
  end
end
