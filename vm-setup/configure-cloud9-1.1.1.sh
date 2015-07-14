set +v

# Generate Gemfile and Gemfile.lock
echo "source 'https://rubygems.org'

ruby '2.2.2'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '5.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '2.7.1'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :production do
gem 'pg'
end

group :development, :test do

  gem 'cucumber-rails', '1.4.2'
  gem 'rspec-rails', '3.3.2'
  gem 'capybara', '2.4.4'
  gem 'database_cleaner', '1.4.1'
  gem 'ZenTest', '4.11.0'
  gem 'protected_attributes'
  gem 'haml'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end" > Gemfile

echo "GEM
  remote: https://rubygems.org/
  specs:
    ZenTest (4.11.0)
    actionmailer (4.2.1)
      actionpack (= 4.2.1)
      actionview (= 4.2.1)
      activejob (= 4.2.1)
      mail (~> 2.5, >= 2.5.4)
      rails-dom-testing (~> 1.0, >= 1.0.5)
    actionpack (4.2.1)
      actionview (= 4.2.1)
      activesupport (= 4.2.1)
      rack (~> 1.6)
      rack-test (~> 0.6.2)
      rails-dom-testing (~> 1.0, >= 1.0.5)
      rails-html-sanitizer (~> 1.0, >= 1.0.1)
    actionview (4.2.1)
      activesupport (= 4.2.1)
      builder (~> 3.1)
      erubis (~> 2.7.0)
      rails-dom-testing (~> 1.0, >= 1.0.5)
      rails-html-sanitizer (~> 1.0, >= 1.0.1)
    activejob (4.2.1)
      activesupport (= 4.2.1)
      globalid (>= 0.3.0)
    activemodel (4.2.1)
      activesupport (= 4.2.1)
      builder (~> 3.1)
    activerecord (4.2.1)
      activemodel (= 4.2.1)
      activesupport (= 4.2.1)
      arel (~> 6.0)
    activesupport (4.2.1)
      i18n (~> 0.7)
      json (~> 1.7, >= 1.7.7)
      minitest (~> 5.1)
      thread_safe (~> 0.3, >= 0.3.4)
      tzinfo (~> 1.1)
    arel (6.0.0)
    binding_of_caller (0.7.2)
      debug_inspector (>= 0.0.1)
    builder (3.2.2)
    byebug (5.0.0)
      columnize (= 0.9.0)
    capybara (2.4.4)
      mime-types (>= 1.16)
      nokogiri (>= 1.3.3)
      rack (>= 1.0.0)
      rack-test (>= 0.5.4)
      xpath (~> 2.0)
    coffee-rails (4.1.0)
      coffee-script (>= 2.2.0)
      railties (>= 4.0.0, < 5.0)
    coffee-script (2.4.1)
      coffee-script-source
      execjs
    coffee-script-source (1.9.1.1)
    columnize (0.9.0)
    cucumber (1.3.20)
      builder (>= 2.1.2)
      diff-lcs (>= 1.1.3)
      gherkin (~> 2.12)
      multi_json (>= 1.7.5, < 2.0)
      multi_test (>= 0.1.2)
    cucumber-rails (1.4.2)
      capybara (>= 1.1.2, < 3)
      cucumber (>= 1.3.8, < 2)
      mime-types (>= 1.16, < 3)
      nokogiri (~> 1.5)
      rails (>= 3, < 5)
    database_cleaner (1.4.1)
    debug_inspector (0.0.2)
    diff-lcs (1.2.5)
    erubis (2.7.0)
    execjs (2.5.2)
    gherkin (2.12.2)
      multi_json (~> 1.3)
    globalid (0.3.5)
      activesupport (>= 4.1.0)
    haml (4.0.6)
      tilt
    i18n (0.7.0)
    jbuilder (2.3.1)
      activesupport (>= 3.0.0, < 5)
      multi_json (~> 1.2)
    jquery-rails (4.0.4)
      rails-dom-testing (~> 1.0)
      railties (>= 4.2.0)
      thor (>= 0.14, < 2.0)
    json (1.8.3)
    loofah (2.0.2)
      nokogiri (>= 1.5.9)
    mail (2.6.3)
      mime-types (>= 1.16, < 3)
    mime-types (2.6.1)
    mini_portile (0.6.2)
    minitest (5.7.0)
    multi_json (1.11.2)
    multi_test (0.1.2)
    nokogiri (1.6.6.2)
      mini_portile (~> 0.6.0)
    pg (0.18.2)
    protected_attributes (1.1.0)
      activemodel (>= 4.0.1, < 5.0)
    rack (1.6.4)
    rack-test (0.6.3)
      rack (>= 1.0)
    rails (4.2.1)
      actionmailer (= 4.2.1)
      actionpack (= 4.2.1)
      actionview (= 4.2.1)
      activejob (= 4.2.1)
      activemodel (= 4.2.1)
      activerecord (= 4.2.1)
      activesupport (= 4.2.1)
      bundler (>= 1.3.0, < 2.0)
      railties (= 4.2.1)
      sprockets-rails
    rails-deprecated_sanitizer (1.0.3)
      activesupport (>= 4.2.0.alpha)
    rails-dom-testing (1.0.6)
      activesupport (>= 4.2.0.beta, < 5.0)
      nokogiri (~> 1.6.0)
      rails-deprecated_sanitizer (>= 1.0.1)
    rails-html-sanitizer (1.0.2)
      loofah (~> 2.0)
    railties (4.2.1)
      actionpack (= 4.2.1)
      activesupport (= 4.2.1)
      rake (>= 0.8.7)
      thor (>= 0.18.1, < 2.0)
    rake (10.4.2)
    rdoc (4.2.0)
    rspec-core (3.3.1)
      rspec-support (~> 3.3.0)
    rspec-expectations (3.3.0)
      diff-lcs (>= 1.2.0, < 2.0)
      rspec-support (~> 3.3.0)
    rspec-mocks (3.3.1)
      diff-lcs (>= 1.2.0, < 2.0)
      rspec-support (~> 3.3.0)
    rspec-rails (3.3.2)
      actionpack (>= 3.0, < 4.3)
      activesupport (>= 3.0, < 4.3)
      railties (>= 3.0, < 4.3)
      rspec-core (~> 3.3.0)
      rspec-expectations (~> 3.3.0)
      rspec-mocks (~> 3.3.0)
      rspec-support (~> 3.3.0)
    rspec-support (3.3.0)
    sass (3.4.15)
    sass-rails (5.0.3)
      railties (>= 4.0.0, < 5.0)
      sass (~> 3.1)
      sprockets (>= 2.8, < 4.0)
      sprockets-rails (>= 2.0, < 4.0)
      tilt (~> 1.1)
    sdoc (0.4.1)
      json (~> 1.7, >= 1.7.7)
      rdoc (~> 4.0)
    spring (1.3.6)
    sprockets (3.2.0)
      rack (~> 1.0)
    sprockets-rails (2.3.2)
      actionpack (>= 3.0)
      activesupport (>= 3.0)
      sprockets (>= 2.8, < 4.0)
    sqlite3 (1.3.10)
    thor (0.19.1)
    thread_safe (0.3.5)
    tilt (1.4.1)
    turbolinks (2.5.3)
      coffee-rails
    tzinfo (1.2.2)
      thread_safe (~> 0.1)
    uglifier (2.7.1)
      execjs (>= 0.3.0)
      json (>= 1.8.0)
    web-console (2.1.3)
      activemodel (>= 4.0)
      binding_of_caller (>= 0.7.2)
      railties (>= 4.0)
      sprockets-rails (>= 2.0, < 4.0)
    xpath (2.0.0)
      nokogiri (~> 1.3)

PLATFORMS
  ruby

DEPENDENCIES
  ZenTest (= 4.11.0)
  byebug
  capybara (= 2.4.4)
  coffee-rails (~> 4.1.0)
  cucumber-rails (= 1.4.2)
  database_cleaner (= 1.4.1)
  haml
  jbuilder (~> 2.0)
  jquery-rails
  pg
  protected_attributes
  rails (= 4.2.1)
  rspec-rails (= 3.3.2)
  sass-rails (~> 5.0)
  sdoc (~> 0.4.0)
  spring
  sqlite3
  turbolinks
  uglifier (>= 1.3.0)
  web-console (~> 2.0)

BUNDLED WITH
   1.10.4" > Gemfile.lock

# install heroku
sudo apt-get install heroku-toolbelt

# install the correct version of ruby
rvm install ruby-2.2.2
rvm use --default ruby-2.2.2
cd .

# install all the needed gems
gem install bundler:1.10.4

bundle install
