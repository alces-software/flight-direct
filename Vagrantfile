# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

$dev_path='/tmp/omnibus-flight-direct'
$profile='/etc/profile.d/fd-vagrant.sh'
$credentials="#{ENV['HOME']}/.credentials.sh"

$master_script = <<-MASTER_SCRIPT
# Put the development tools on the path
echo 'source #{$dev_path}/vagrant_bin/dev_bin_setup' > #{$profile}

# Load the aws credentials into the vm environment. Vagrant can not
# provision files directly into a root diretory BUT this script is
# ran as `sudo`. Thus a heredoc is used to write into profile.d
cat <<'EOF' > /etc/profile.d/vm_host_credentials.sh
#{File.read($credentials) if File.exist?($credentials)}
EOF
MASTER_SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box = 'centos/7'
  config.vm.network "private_network", type: 'dhcp'
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.define 'master', primary: true do |master|
    master.vm.hostname = 'master'
    master.vm.synced_folder '.', $dev_path
    master.vm.synced_folder '../forge-cli', '/tmp/forge'
    master.vm.synced_folder '../anvil', '/tmp/anvil'
    master.vm.synced_folder '../gridware', '/tmp/gridware'
    master.vm.provision 'shell', inline: $master_script
    nproc = `nproc`.to_i
    master.vm.provider('virtualbox') { |v| nproc > 1 ? nproc - 1 : 1 }
  end

  config.vm.define 'slave' do |slave|
    slave.vm.hostname = 'slave'
  end
end
