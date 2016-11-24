# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
	config.vm.provider "virtualbox"
	config.vm.box = "ubuntu/trusty64"
	
	config.ssh.pty = false
	config.ssh.forward_agent = true
	
	M = 3
	config.vm.define "manager1" do |manager|
		manager.vm.hostname = "manager-1"
		manager.vm.network "private_network", ip: "192.168.5.11"
                manager.vm.provision "shell", inline: "bash /vagrant/scripts/consul/bootstrap.sh"
		manager.vm.provision "shell", path: "https://get.docker.com"
		manager.vm.provision "shell", inline: "bash /vagrant/scripts/docker/install.sh"
        end
	(2..M).each do |machine_id|
		config.vm.define "manager#{machine_id}" do |manager|
			manager.vm.hostname = "manager-#{machine_id}"
			manager.vm.network "private_network", ip: "192.168.5.#{10+machine_id}"
			manager.vm.provision "shell", inline: "bash /vagrant/scripts/consul/server.sh 192.168.5.#{(10+1..10+M).to_a.join(' 192.168.5.')}"
			manager.vm.provision "shell", path: "https://get.docker.com"
			manager.vm.provision "shell", inline: "bash /vagrant/scripts/docker/manager.sh 192.168.5.11"
		end
	end
	
	W = 3
	(1..W).each do |machine_id|
		config.vm.define "worker#{machine_id}" do |worker|
    			worker.vm.hostname = "worker-#{machine_id}"
    			worker.vm.network "private_network", ip: "192.168.5.#{100+machine_id}"
			worker.vm.provision "shell", inline: "bash /vagrant/scripts/consul/agent.sh 192.168.5.#{(10+1..10+W).to_a.join(' 192.168.5.')}"
			worker.vm.provision "shell", path: "https://get.docker.com"
			worker.vm.provision "shell", inline: "bash /vagrant/scripts/docker/worker.sh 192.168.5.11"
		end
	end
end
