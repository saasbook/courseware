# NOTICE: PLEASE RUN THIS SCRIPT ON CLOUD9 USING THE FOLLOWING COMMAND
# xxx@xxx: ~/workspace $ bash --login configure-cloud9-1.1.2.sh

set +v

# Generate Gemfile and Gemfile.lock
echo "source 'https://rubygems.org'

ruby '2.2.2'

# Armando's requests
gem 'autotest-rails' 
gem 'jasmine-rails' 
gem 'jasmine-jquery-rails' 
gem 'factory_girl' 
gem 'cucumber-rails-training-wheels'          # basic web steps like "I should see..." 
gem 'timecop' 
gem 'cucumber-timecop', :require => false   # for testing code that relies on time of day 
gem 'poltergeist'#used for headless-browser and js 

# Juan's Requests
gem 'sinatra', '>= 1.4'
gem 'sinatra-flash', '0.3.0'

# Sid's Requests
gem 'rails', '4.2.1'
gem 'sqlite3'
gem 'sass-rails', '5.0.3'
gem 'uglifier', '2.7.1'
gem 'coffee-rails', '4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'arel', '6.0.0'
gem 'protected_attributes', '1.1.0'
gem 'rspec-core', '3.3.1'
gem 'rspec-expectations', '3.3.0'
gem 'rspec-mocks', '3.3.1'
gem 'sass', '3.4.15'
gem 'web-console', '2.1.3'

group :production do
  gem 'pg'
end

# Merge Juan and Sid's Requests
group :development, :test do
  gem 'cucumber-rails', '1.4.2'
  gem 'cucumber-sinatra', '0.5.0'
  gem 'capybara', '2.4.4'

  gem 'rspec', '3.3.0'
  gem 'rspec-autotest', '1.0.0'
  gem 'rspec-rails', '3.3.2'

  gem 'rack-test', '0.6.3'
  gem 'rack_session_access', '0.1.1'

  gem 'byebug', '5.0.0'
  gem 'launchy', '2.4.3'
  gem 'rerun', '0.10.0'

  gem 'simplecov', '0.10.0'
  gem 'webmock', '1.21.0'
  gem 'ZenTest', '4.11.0'

  gem 'database_cleaner', '1.4.1'
  gem 'haml'
  gem 'spring'
end" > Gemfile

# install heroku
sudo apt-get install heroku-toolbelt

# install the correct version of ruby
rvm install ruby-2.2.2
rvm use ruby-2.2.2

# install all the needed gems
gem install bundler:1.10.4
gem install cucumber:1.3.8
gem install cucumber:2.0.0

bundle install
