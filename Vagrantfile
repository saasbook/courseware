# -*- coding: utf-8 -*-
# -*- mode: ruby -*-
# vi: set ft=ruby :

=begin
   Welcome to BerkeleyX: CS169.1x Engineering Software as a Service!

   If you're using Ubuntu or other operating system based on Debian then
   you can use these instructions to get started. These instructions also
   assume you're using Virtualbox when you install Vagrant; not VMware. 

 
   How to use this vagrant file:

   0) Download this Vagrantfile and put it where you want to have your
      working folder. 

   1) Download and install vagrant:
          "http://docs.vagrantup.com/v2/installation/index.html"

   2) Vagrant up!
          "http://docs.vagrantup.com/v2/getting-started/up.html"

   3) Vagrant ssh! It should look like this:
       $ vagrant ssh
       vagrant@precise64:~$ 

   4) Configure the vagrant box:
         A. Install git 
            vagrant@precise64:~$ sudo apt-get install git-core

         B. git clone this repository while in your vagrant box
            $ git clone https://github.com/saasbook/courseware.git

         C. Use the shell script to install what's needed for the course
            $ chmod +x courseware/vm-setup/configure-image-0.10.3.sh
            $ ./courseware/vm-setup/configure-image-0.10.3.sh

         D. Go for a walk.

   5) Optional configuration. You may want to write code on your laptop and
      then execute that code in the vagrant box. This will let you use your
      favorite text editor, probably Emacs (it comes with tetris), but
      execute your code in a vagrant box; a much better place to break
      things than your laptop. You can do this using shared folders on
      Vagrant. 

      This step can be a headache & you can get a similar result by just
      sending your code to a git repository then pulling it to your Vagrant
      box.

      Here's one way to set up a shared folder (between your laptop and your
      Vagrant box). Do these steps on your laptop (local machine):

          $  sudo apt-get install nfs-common
          $  sudo apt-get update
          $  sudo apt-get install nfs-kernel-server﻿
          $  sudo apt-get update

     Next, edit this Vagrantfile by uncommenting as specified in the
     optional configuration portion of this file. Then do these steps on
     your local machine.

          $ vagrant reload
          $ # test this out 
          $ vagrant ssh
          $ touch echo "hello world" > hello.txt
          $ exit
          $ ls # you should see hello.txt with hello world inside

=end

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "hashicorp/precise64"

  ########### Start Optional Configuration #########################

  ## Uncomment everything in here with one '#' to set up optional config
  
  #config.vm.network "private_network", ip: "192.168.56.105"
  
  ## Use NFS for the shared folder
  #config.vm.synced_folder ".", "/vagrant",
  #id: "core",
  #:nfs => true,
  #:mount_options => ['nolock,vers=3,udp,noatime']
 
  ## If using VirtualBox
  #config.vm.provider :virtualbox do |vb|
  #end

  ######### End Optional Configuration #############################
end
