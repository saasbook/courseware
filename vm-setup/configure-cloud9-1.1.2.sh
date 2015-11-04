# Please pipe this script to a "bash --login" shell
RUBY=2.2.2
set +v

# install the correct version of ruby
rvm install ruby-$RUBY

# reload rvm so it can modify environment of running shell script
. /usr/local/rvm/scripts/rvm
rvm use $RUBY

echo rvm use $RUBY >> $HOME/.profile

/bin/bash <<EOF
# install gems. Do not modify this list directly -- see Gemfile
#  in this repo for instructions!
gen install --no-rdoc --no-ri bundler:1.10.6
gem install --no-rdoc --no-ri rspec:3.3.0
EOF
