# -*- mode: ruby -*-
# vi: set ft=ruby :

guest_os = "ubuntu/xenial64"

nodes = [
  { :hostname => 'web1', :ram => 1024, :ip => '192.168.2.10', :role=> 'web' },
  { :hostname => 'web2', :ram => 1024, :ip => '192.168.2.11' , :role=> 'web' },
  { :hostname => 'cron', :ram => 1024, :ip => '192.168.2.20' , :role=> 'worker' },
  { :hostname => 'worker', :ram => 1024, :ip => '192.168.2.30', :role=> 'cron' },
  { :hostname => 'ably', :ram => 1024, :ip => '192.168.2.40' , :role=> 'ably' },
  { :hostname => 'mysql', :ram => 1024, :ip => '192.168.2.50', :role=> 'mysql' },
  { :hostname => 'redis', :ram => 1024, :ip => '192.168.2.60', :role=> 'redis' },
  { :hostname => 'staging', :ram => 1024, :ip => '192.168.2.70', :role=> 'staging' },
  { :hostname => 'jumpbox', :ram => 1024, :ip => '192.168.2.80', :role=> 'jumpbox' }
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
        vb.name = node[:hostname]
        vb.check_guest_additions = false
        vb.memory = node[:ram]
      end

      nodeconfig.vm.provision "shell", privileged: true, path: "scripts/bootstrap.sh"

      nodeconfig.vm.provision :shell, privileged: true, path: "scripts/#{node[:role]}.sh"
      if ["jumpbox"].include? node[:role]
        nodeconfig.vm.synced_folder ".", "/opt/capistrano_rvm_eye", owner: "ubuntu"
      end
    end
  end

end
