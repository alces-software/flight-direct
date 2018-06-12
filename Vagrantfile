# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

$dev_path='/tmp/omnibus-flight-direct'

$master_script = <<-MASTER_SCRIPT
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable --ruby

# Use the developmet ruby code instead of that installed by the rpm
echo "export FLIGHT_DIRECT_RUBY_SOURCE=#{$dev_path}" >> ~/.bashrc
sudo su -
echo "export FLIGHT_DIRECT_RUBY_SOURCE=#{$dev_path}" >> ~/.bashrc
MASTER_SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box = 'centos/7'
  config.vm.network "private_network", type: 'dhcp'
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.define 'master', primary: true do |master|
    master.vm.hostname = 'master'
    master.vm.synced_folder '.', $dev_path
    master.vm.provision 'shell', inline: $master_script
  end

  config.vm.define 'slave' do |slave|
    slave.vm.hostname = 'slave'
  end
end
