Introduction
Vagrant could be configured in multiple platforms including MAC OS X, Microsoft Windows, Debian, Ubuntu, CentOS, RedHat and Fedora, in this document we will handle how to configure and run virtual development environment through Vagrant from the beginning, on Ubuntu and Windows environments.


1) Ubuntu Environment
To configure Vagrant inside Ubuntu environment, we should to follow the following sections
  - Installing Vagrant
  - Create Vagrant Machine Folders
  - Installing Precise32 Box
  - Creating New Virtual Machine
  - Downloading Virtual Machine Configuration Script Shell
  - Configuring Permissions for Virtual Machine Configuration Script Shell

  1.1)Installing Vagrant
First thing, we need to install vagrant packages from advanced packaging tool (apt-get) by executing the following command

  sudo apt-get install vagrant

This will require us to enter administrator password, enter it and confirm to download.

Example below
      administrator@host01:~$ sudo apt-get install vagrant
      [sudo] password for administrator: 
      Reading package lists... Done
      Building dependency tree       
      Reading state information... Done
      The following extra packages will be installed:
        bsdtar curl dkms libgsoap3 libruby1.9.1 libsdl1.2debian libyaml-0-2 ruby
        ruby-childprocess ruby-erubis ruby-ffi ruby-i18n ruby-log4r ruby-net-scp
        ruby-net-ssh ruby1.9.1 virtualbox virtualbox-dkms virtualbox-qt
      Suggested packages:
        bsdcpio debhelper ri ruby-dev ruby1.9.1-examples ri1.9.1 graphviz
        ruby1.9.1-dev ruby-switch virtualbox-guest-additions-iso vde2
      The following NEW packages will be installed:
        bsdtar curl dkms libgsoap3 libruby1.9.1 libsdl1.2debian libyaml-0-2 ruby
        ruby-childprocess ruby-erubis ruby-ffi ruby-i18n ruby-log4r ruby-net-scp
        ruby-net-ssh ruby1.9.1 vagrant virtualbox virtualbox-dkms virtualbox-qt
      0 upgraded, 20 newly installed, 0 to remove and 11 not upgraded.
      Need to get 25.2 MB of archives.
      After this operation, 94.8 MB of additional disk space will be used.
      Do you want to continue [Y/n]? Y

  1.2) Create Vagrant Machine Folders
Folders could be created based on your choice; in our case, we will create the following folders in the home folder:
Vagrant -> Projects -> VM_169.x, to create them we should to use the following command from the home folder

  mkdir Vagrant
  mkdir Vagrant/Projects
  mkdir Vagrant/Projects/VM_169.x

Example below
      administrator@host01:~$ mkdir Vagrant
      administrator@host01:~$ mkdir Vagrant/Projects
      administrator@host01:~$ mkdir Vagrant/Projects/VM_169.x
      administrator@host01:~$ cd ~/Vagrant/Projects/VM_169.x
      administrator@host01:~/Vagrant/Projects/VM_169.x$


