---
layout: page
title: "New Rails app setup"
category: rails
date: 2017-11-02 09:37:08
---

Throughout the book we recommend several tools for developing, testing,
deploying, and monitoring the code quality of your app.  In this
section, we pull together in one place a step-by-step list for creating
a new app that takes advantage of all these tools.  
This section will only make sense after you have read all the referenced
sections, so use it as a reference and don't worry if you don't
understand all the steps now.  Many steps are
annotated with the section number(s) from 
[Engineering Software as a Service](https://www.saasbook.info)
in which the tool or concept 
is first introduced.

## Set up the app

If you're doing this as a team, _one_ person should do this 

1.  Run `rails -v` to ensure you're running the desired version of
  Rails.  If not, run `gem install rails -v` _x.x.x_ with _x.x.x_ set to the version you want; 4.2.9 for example.

2. Run `rails new` _appname_ `-T` to create the new app.
  `-T` skips creating the `test` subdirectory used by the
  `Test::Unit` testing framework, since we recommend
  using RSpec instead.  

3. `cd` _appname_ to navigate into your new app's root
  directory.  From now on, all shell commands should be issued from this
  directory.

4. Edit the `Gemfile`
  to lock the versions of Ruby and Rails, for example:

```ruby
# in Gemfile:
ruby '2.2.2'    # Ruby version you're running
rails '4.2.1'  # Rails version for this app
```

If you ended up changing the version(s) already present in the
Gemfile, run `bundle install --without production` to make sure
you have compatible versions of Rails and other gems.

5. Make sure your app runs by executing
  `rails server -p $PORT -b $IP` and visiting the app's root URI.
  You should see the Rails welcome page.  (If not using Cloud9, just use
  `rails server`.)

6. `git init` to set up your app's root directory as a GitHub
  repo.  (\ref{sec:git}, Screencast \ref{sc:gitbasics})

##  Connect your app to GitHub, CodeClimate, Travis CI, and Heroku

1. Create a GitHub repo via GitHub's web
  interface, and do the initial commit and push of your new app's
  repo. (\ref{sec:intro_github})  

2. Point CodeClimate at your app's GitHub
  repo.   (\ref{sec:metrics})  Add a CodeClimate badge to your
  repo's `README.md` (``splash page'') so you can always see the
  latest CodeClimate results.

3. Point your Travis CI account it at your app's GitHub
  repo (\ref{sec:ci}).  Add a Travis CI badge to `README.md` to see the latest status
  of running tests.

4. Set up a Pivotal Tracker project to track user stories and
  velocity.  (\ref{sec:points}) 

5. Make the changes necessary to your Gemfile for deploying to
  production on Heroku. (\ref{sec:Heroku})

```ruby
# make sure references to sqlite3 gem ONLY appear in dev/test groups
group :development, :test do
  gem 'sqlite3'
end 

# make sure the following gems are in your production group:
group :production do
  gem 'pg'              # use PostgreSQL in production (Heroku)
  gem 'rails_12factor'  # Heroku-specific production settings
end
```

6. Run `bundle install --without production`
  if you've changed your `Gemfile`.  Commit the
  changes to `Gemfile` and `Gemfile.lock`.  On future changes to the
  Gemfile, 
  you can just say `bundle` with no arguments, since Bundler will
  remember the option to 
  skip production gems.


7. Run `heroku apps:create` _appname_ to create your new app on Heroku

8. Run `git push heroku master` to ensure the app deploys correctly.

## Set up your testing environment

1. Add support in your Gemfile for Cucumber, RSpec, interactive
debugging, code coverage, factories, local metric collection (optional),
and (if you plan to use JavaScript
in your app) Jasmine:

```ruby
group :development, :test do
  gem 'jasmine-rails' # if you plan to use JavaScript/CoffeeScript
end
# setup Cucumber, RSpec, Guard support
group :test do
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'simplecov', :require => false
  gem 'cucumber-rails', :require => false
  gem 'cucumber-rails-training-wheels' # basic imperative step defs
  gem 'database_cleaner' # required by Cucumber
  gem 'factory_girl_rails' # if using FactoryGirl
  gem 'metric_fu'        # collect code metrics
end
```

(See Section \ref{sec:testing_ajax} for additional gems to support
fixtures and AJAX stubbing in your JavaScript tests.)

2. Run `bundle`, since you've changed your `Gemfile`.  Commit the
  changes to `Gemfile` and `Gemfile.lock`.

3. If all is well, create the subdirectories and files used by
   RSpec,  Cucumber, Jasmine, and if you're using
  them, the basic Cucumber imperative steps:

```bash
rails generate rspec:install
rails generate cucumber:install
rails generate cucumber_rails_training_wheels:install
rails generate jasmine_rails:install
bundle exec guard init rspec
```

4. If you're using SimpleCov, which we recommend, place the following
  lines at the _top_ of `spec\slash{`spec\_helper.rb} to enable
  it:

```ruby
# at TOP of spec/rails_helper.rb:
require 'simplecov'
SimpleCov.start
```

5. If you're using FactoryGirl to manage factories
  (\ref{sec:fixtures}), add its setup code:

```ruby
# For RSpec, create this file as spec/support/factory_girl.rb
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
```

```ruby
# For Cucumber, add at the end of features/support/env.rb:
World(FactoryGirl::Syntax::Methods)
```

6. `git add` and then commit any files created or modified by these steps.

7. Ensure Heroku deployment still works: `git push heroku master`

## Create the first migration

You're now ready to create and apply the first migration,
(\ref{sec:rails_databases}),
then re-deploy to Heroku and apply the migration in production
(`heroku run rake db:migrate`).

## Add other useful Gems

Some that we recommend include:

* `railroady` draws diagrams of your class relationships such as
  has-many, belongs-to, and so on (\ref{sec:associations})
* `omniauth` adds portable third-party authentication
  (\ref{sec:authentication})
* `devise` adds user self-signup pages, and optionally works with
  `omniauth` 
