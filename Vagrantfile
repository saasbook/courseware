# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  # experimental: alternatively use the 64-bit image
  #config.vm.box = "hashicorp/precise64"
  config.vm.box = "hashicorp/precise32"
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.provision :shell, :path => "vm-setup/configure-image-vagrant-0.10.3.sh"
end
