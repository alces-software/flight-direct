# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

$master_script = <<-MASTER_SCRIPT
  sudo su -
  echo "PATH=$PATH:/opt/flight-direct/opt/ruby/bin" >> /root/bashrc
MASTER_SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box = 'centos/7'
  config.vm.network "private_network", type: 'dhcp'
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.define 'master', primary: true do |master|
    master.vm.hostname = 'master'
    master.vm.synced_folder '.', '/tmp/omnibus-flight-direct'
    master.vm.provision 'shell', inline: $master_script
  end

  config.vm.define 'slave' do |slave|
    slave.vm.hostname = 'slave'
  end
end
