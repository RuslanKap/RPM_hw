# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"

  config.vm.provider "virtualbox" do |v|
    v.memory = 512
    v.cpus = 1
  end

  config.vm.define "rpm" do |rpm|
    rpm.vm.network "private_network", ip: "192.168.56.10"
    rpm.vm.hostname = "rpm"
    rpm.vm.provision "shell", path: "conf.sh"
  end
end