# Please pipe this script to a "bash --login" shell
RUBY=2.3.0
set +v

# to get /usr/share/dict/words
# sudo apt-get install wamerican  # armandofox: commented out since it seems to be causing pain for some people
# install heroku
sudo apt-get install heroku-toolbelt

# install PhantomJS for running JavaScript tests headless
npm install phantomjs-prebuilt
# install the correct version of ruby
echo yes | rvm remove all
rvm install ruby-$RUBY
# reload rvm so it can modify environment of running shell script
. /usr/local/rvm/scripts/rvm
rvm use $RUBY
echo rvm use $RUBY >> $HOME/.profile

/bin/bash <<EOF
# install gems. Do not modify this list directly -- see Gemfile
#  in this repo for instructions!
gem install --no-rdoc --no-ri ZenTest:4.11.0
gem install --no-rdoc --no-ri actionmailer:4.2.1
gem install --no-rdoc --no-ri actionpack:4.2.1
gem install --no-rdoc --no-ri actionview:4.2.1
gem install --no-rdoc --no-ri activejob:4.2.1
gem install --no-rdoc --no-ri activemodel:4.2.1
gem install --no-rdoc --no-ri activerecord:4.2.1
gem install --no-rdoc --no-ri activesupport:4.2.1
gem install --no-rdoc --no-ri addressable:2.3.8
gem install --no-rdoc --no-ri arel:6.0.0
gem install --no-rdoc --no-ri autotest-rails:4.2.1
gem install --no-rdoc --no-ri binding_of_caller:0.7.2
gem install --no-rdoc --no-ri builder:3.2.2
gem install --no-rdoc --no-ri byebug:5.0.0
gem install --no-rdoc --no-ri capybara:2.4.4
gem install --no-rdoc --no-ri celluloid:0.16.1
gem install --no-rdoc --no-ri chronic:0.10.2
gem install --no-rdoc --no-ri cliver:0.3.2
gem install --no-rdoc --no-ri coffee-rails:4.1.0
gem install --no-rdoc --no-ri coffee-script:2.4.1
gem install --no-rdoc --no-ri coffee-script-source:1.9.1.1
gem install --no-rdoc --no-ri columnize:0.9.0
gem install --no-rdoc --no-ri crack:0.4.2
gem install --no-rdoc --no-ri cucumber:1.3.20
gem install --no-rdoc --no-ri cucumber-rails:1.4.2
gem install --no-rdoc --no-ri cucumber-rails-training-wheels:1.0.0
gem install --no-rdoc --no-ri cucumber-sinatra:0.5.0
gem install --no-rdoc --no-ri cucumber-timecop:0.0.5
gem install --no-rdoc --no-ri database_cleaner:1.4.1
gem install --no-rdoc --no-ri debug_inspector:0.0.2
gem install --no-rdoc --no-ri diff-lcs:1.2.5
gem install --no-rdoc --no-ri docile:1.1.5
gem install --no-rdoc --no-ri erubis:2.7.0
gem install --no-rdoc --no-ri execjs:2.5.2
gem install --no-rdoc --no-ri extlib:0.9.16
gem install --no-rdoc --no-ri factory_girl:4.5.0
gem install --no-rdoc --no-ri ffi:1.9.10
gem install --no-rdoc --no-ri gherkin:2.12.2
gem install --no-rdoc --no-ri globalid:0.3.6
gem install --no-rdoc --no-ri haml:4.0.7
gem install --no-rdoc --no-ri highline:1.7.3
gem install --no-rdoc --no-ri hitimes:1.2.2
gem install --no-rdoc --no-ri i18n:0.7.0
gem install --no-rdoc --no-ri jasmine-core:2.4.1
gem install --no-rdoc --no-ri jasmine-jquery-rails:2.0.3
gem install --no-rdoc --no-ri jasmine-rails:0.11.0
gem install --no-rdoc --no-ri jbuilder:2.3.1
gem install --no-rdoc --no-ri jquery-rails:4.0.4
gem install --no-rdoc --no-ri json:1.8.3
gem install --no-rdoc --no-ri launchy:2.4.3
gem install --no-rdoc --no-ri listen:2.10.1
gem install --no-rdoc --no-ri loofah:2.0.2
gem install --no-rdoc --no-ri mail:2.6.3
gem install --no-rdoc --no-ri mime-types:2.6.1
gem install --no-rdoc --no-ri mini_portile:0.6.2
gem install --no-rdoc --no-ri minitest:5.8.0
gem install --no-rdoc --no-ri multi_json:1.11.2
gem install --no-rdoc --no-ri multi_test:0.1.2
gem install --no-rdoc --no-ri nokogiri:1.6.6.2
gem install --no-rdoc --no-ri pg:0.18.2
gem install --no-rdoc --no-ri phantomjs:1.9.8.0
gem install --no-rdoc --no-ri poltergeist:1.6.0
gem install --no-rdoc --no-ri protected_attributes:1.1.0
gem install --no-rdoc --no-ri rack:1.6.4
gem install --no-rdoc --no-ri rack-protection:1.5.3
gem install --no-rdoc --no-ri rack-test:0.6.3
gem install --no-rdoc --no-ri rack_session_access:0.1.1
gem install --no-rdoc --no-ri rails:4.2.1
gem install --no-rdoc --no-ri rails-deprecated_sanitizer:1.0.3
gem install --no-rdoc --no-ri rails-dom-testing:1.0.6
gem install --no-rdoc --no-ri rails-html-sanitizer:1.0.2
gem install --no-rdoc --no-ri railties:4.2.1
gem install --no-rdoc --no-ri rake:10.4.2
gem install --no-rdoc --no-ri rb-fsevent:0.9.5
gem install --no-rdoc --no-ri rb-inotify:0.9.5
gem install --no-rdoc --no-ri rdoc:4.2.0
gem install --no-rdoc --no-ri rerun:0.10.0
gem install --no-rdoc --no-ri rspec:3.3.0
gem install --no-rdoc --no-ri rspec-autotest:1.0.0
gem install --no-rdoc --no-ri rspec-core:3.3.1
gem install --no-rdoc --no-ri rspec-expectations:3.3.0
gem install --no-rdoc --no-ri rspec-mocks:3.3.1
gem install --no-rdoc --no-ri rspec-rails:3.3.2
gem install --no-rdoc --no-ri rspec-support:3.3.0
gem install --no-rdoc --no-ri safe_yaml:1.0.4
gem install --no-rdoc --no-ri sass:3.4.15
gem install --no-rdoc --no-ri sass-rails:5.0.3
gem install --no-rdoc --no-ri sdoc:0.4.1
gem install --no-rdoc --no-ri simplecov:0.10.0
gem install --no-rdoc --no-ri simplecov-html:0.10.0
gem install --no-rdoc --no-ri sinatra:1.4.6
gem install --no-rdoc --no-ri sinatra-flash:0.3.0
gem install --no-rdoc --no-ri spring:1.3.6
gem install --no-rdoc --no-ri sprockets:3.2.0
gem install --no-rdoc --no-ri sprockets-rails:2.3.2
gem install --no-rdoc --no-ri sqlite3:1.3.10
gem install --no-rdoc --no-ri templater:1.0.0
gem install --no-rdoc --no-ri thor:0.19.1
gem install --no-rdoc --no-ri thread_safe:0.3.5
gem install --no-rdoc --no-ri tilt:1.4.1
gem install --no-rdoc --no-ri timecop:0.8.0
gem install --no-rdoc --no-ri timers:4.0.1
gem install --no-rdoc --no-ri turbolinks:2.5.3
gem install --no-rdoc --no-ri tzinfo:1.2.2
gem install --no-rdoc --no-ri uglifier:2.7.1
gem install --no-rdoc --no-ri web-console:2.1.3
gem install --no-rdoc --no-ri webmock:1.21.0
gem install --no-rdoc --no-ri websocket-driver:0.6.2
gem install --no-rdoc --no-ri websocket-extensions:0.1.2
gem install --no-rdoc --no-ri xpath:2.0.0
EOF
