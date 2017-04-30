# -*- mode: ruby -*-
# vi: set ft=ruby :

guest_os = "ubuntu/xenial64"

nodes = [
  { :hostname => 'web',  :ram => 128, :ip => '192.168.2.10' },
  { :hostname => 'cron', :ram => 128, :ip => '192.168.2.20' },
  { :hostname => 'worker', :ram => 128, :ip => '192.168.2.30' },
  { :hostname => 'ably', :ram => 128, :ip => '192.168.2.40' },
  { :hostname => 'mysql', :ram => 128, :ip => '192.168.2.50' },
  { :hostname => 'redis', :ram => 128, :ip => '192.168.2.60' },
  { :hostname => 'staging', :ram => 256, :ip => '192.168.2.70' },
  { :hostname => 'jumpbox', :ram => 256, :ip => '192.168.2.80' }
]

Vagrant.configure("2") do |config|
  config.vm.box_check_update = false

  nodes.each do |node|
    config.vm.define node[:hostname] do |nodeconfig|
      nodeconfig.vm.box = guest_os
      nodeconfig.vm.network "private_network", ip: node[:ip]
      nodeconfig.vm.hostname = node[:hostname] + ".box"

      config.vm.provider "virtualbox" do |vb|
        vb.gui = false
        vb.check_guest_additions = false
        vb.memory = node[:ram]
      end

      nodeconfig.vm.provision "shell", privileged: true, path: "scripts/boostrap.sh"

      nodeconfig.vm.provision :shell, privileged: true, path: "scripts/#{node[:hostname]}.sh"
    end
  end

end
