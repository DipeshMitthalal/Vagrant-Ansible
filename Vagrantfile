# -*- mode: ruby -*-
NUMBER_OF_MACHINES = 2
CPU = 2
MEMORY = 256
ADMIN_USER = "vagrant"
ADMIN_PASSWORD = "vagrant"
VM_VERSION= "ubuntu/trusty64"
#VM_VERSION= "https://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"
VAGRANT_VM_PROVIDER = "virtualbox"

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  groups = {
    "webservers" => ["web[1:#{NUMBER_OF_MACHINES}]"],
    "loadbalancers" => ["load_balancer"],
    "all_groups:children" => ["webservers","loadbalancers"]
  }

  # create some web servers
  # https://docs.vagrantup.com/v2/vagrantfile/tips.html
  (1..NUMBER_OF_MACHINES).each do |i|
    config.vm.define "web#{i}" do |node|
        node.vm.box = VM_VERSION
        node.vm.hostname = "web#{i}"
        node.vm.network :private_network, ip: "10.0.15.2#{i}"
        node.vm.network "forwarded_port", guest: 80, host: "808#{i}"
        node.vm.provider VAGRANT_VM_PROVIDER do |vb|
          vb.memory = MEMORY
        end

    # Only execute once the Ansible provisioner,
    # when all the machines are up and ready.

      if i == NUMBER_OF_MACHINES
          node.vm.provision "ansible" do |ansible|
            ansible.playbook = "pb_web.yml"
            ansible.sudo = true
            ansible.limit = "all"
            ansible.groups = groups
          end
        end

      end
    end


    # create load balancer
    config.vm.define "load_balancer" do |lb_config|
        lb_config.vm.box = VM_VERSION
        lb_config.vm.hostname = "lb"
        lb_config.vm.network :private_network, ip: "10.0.15.11"
        lb_config.vm.network "forwarded_port", guest: 80, host: 8011
        lb_config.vm.provider VAGRANT_VM_PROVIDER do |vb|
          vb.memory = MEMORY
        end
        lb_config.vm.provision "ansible" do |ansible|
          ansible.playbook = "pb_lb.yml"
          ansible.sudo = true
          ansible.groups = groups
        end
    end
end
