# Please pipe this script to a "bash --login" shell
RUBY=2.3.0
set +v

# install the correct version of ruby
echo yes | rvm remove all
rvm install ruby-$RUBY
# reload rvm so it can modify environment of running shell script
. /usr/local/rvm/scripts/rvm
rvm use $RUBY
echo rvm use $RUBY >> $HOME/.profile
