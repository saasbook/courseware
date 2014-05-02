#!/bin/bash
# Simple autograder setup.sh run by Vagrant

apt-get install -y curl
\curl -L https://get.rvm.io | bash -s stable  --ruby=1.9.3
#rvm command output says to do this.
usermod -a -G rvm vagrant
#rvm command output says to do this too.
source /etc/profile.d/rvm.sh
rvm requirements
rvm reload
# remove warning when having ruby version in Gemfile so Heroku uses correct version
rvm rvmrc warning ignore allGemfiles

# Install sqlite3 dev
apt-get -qq install sqlite3 libsqlite3-dev
# Install required libs and optional feedvalidator for typo homework
apt-get -qq install libxml2-dev libxslt-dev
apt-get -qq install python-feedvalidator

# Install unzip for students to easily extract hw-skeletons
apt-get -qq install unzip

# Install postgesql dev
export LANGUAGE="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
sudo apt-get install -y libpq-dev
sudo apt-get install -y postgresql

# need to edit /etc/postgresql/9.1/main/pg_hba.conf
# needs work to handle variable white space
sudo sed -i -e 's/local\s\+all\s\+postgres\s\+peer/local all postgres peer map=basic/g' /etc/postgresql/9.1/main/pg_hba.conf
# need to edit /etc/postgresql/9.1/main/pg_ident.conf
echo "basic vagrant postgres" | sudo tee -a /etc/postgresql/9.1/main/pg_ident.conf
sudo /etc/init.d/postgresql restart


# Install nodejs
add-apt-repository ppa:chris-lea/node.js
apt-get update
apt-get -qq install -y nodejs

wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
gem install rails '3.2.15'

# top-level dir is specified in Vagrantfile as config.vm.synced_folder
cd /courseware/vm-setup/rottenpotatoes
#bundle update --source debugger # should update the Gemfile.lock
bundle install
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:test:prepare
bundle exec rake db:seed


echo "
Done.
############### Post-install  ###############

* Make the terminal prompt display current git branch:
  Make a backup of your ~/.profile and add this at the end.
  You can uncomment the other states if interested.

# Dirty => *, Untracked => %, Stash => $
GIT_PS1_SHOWDIRTYSTATE=1
# GIT_PS1_SHOWUNTRACKEDFILES=1
# GIT_PS1_SHOWSTASHSTATE=1
export PS1='\w\[\033[01;34m\]\$(__git_ps1 \" (%s)\")\[\033[00m\] $ '"
#### Copy-pasters: Here it is raw, unescaped for the echo command:
# export PS1='\w\[\033[01;34m\]$(__git_ps1 " (%s)")\[\033[00m\] $ '
echo "
* To see results of terminal changes you may need to do
  'source ~/.profile', or reopen Terminals.

* Install finished. Do 'vagrant ssh' to get into this box, 'vagrant halt' to stop it.

"
