# Simple BDD feature from scratch (`students` directory)

The `students` directory contains a trivial app that maintains a list of
students, eg in a course.

The livecoding demo is to stand up this app, and create a feature that
verifies that the students are listed in alphabetical order.

We can show two different ways to do this.  The simple way is to look at
the text of the page and use a regex to match two names such that one is
before the other.  The more sophisticated way, which might be needed to
do more complex tests, is to use XPath.

* On a scratch branch, use `rails new` to create the app, or use the
canned version on master branch.  Immediately do `git init` to set it up
as a repo: this is a best practice!
* Make sure the Gemfile includes these
lines in the test group:
```
group :test do
  gem 'cucumber-rails', :require => false
  gem 'cucumber-rails-training-wheels'
  gem 'rspec-rails'
  gem 'database_cleaner'
end
```
And in the main group:
```
  gem 'haml'
```
* Run `bundle install --without production`, then `rails generate
cucumber:install` to generate Cucumber dirs
* Create (or use existing) migration to add a `students` table:
```
    create_table :students, :force => true do |t|
      t.string :first_name
      t.string :last_name
      t.string :sid_number
    end
```
* Add `resources :students` to `routes.rb`
  * Check routes with `rake routes`

* Now to do the feature.  Create or fill in the feature file with:
```
Feature: display students in alpha order

  As an instructor
  So that I can quickly find a student in the list
  I want the students to be displayed in alphabetical order by last name

Scenario: list students in alpha order

  Given student "Armando Fox" exists
  And student "Dorthy Luu" exists
  When I visit the list of all students
  Then "Armando Fox" should appear before "Dorthy Luu"
```
* Run the feature--the steps are all undefined. Let's add them.
```ruby
Given /^student "(.*) (.*)" exists$/ do |first,last|
  Student.create!(:first_name => first, :last_name => last)
end
```
This fails because there is no `Student` class, so we need to add that
in `app/models/student.rb`
* Run again; "I visit the list of students" needs implementing. This
requires adding a route, a controller action, and a view for
`StudentsController#index`.  These are available in master branch.
* Finally, checking if one student name appears before the other.  A
simple step def that can do this is:
```
Then /^"(.*) (.*)" should appear before "(.*) (.*)"$/ do |first1,last1, first2,last2|
  regex = /#{last1}.*#{first1}.*#{last2}.*#{first2}/
  expect(page.text).to match(regex)
end
```
* However, as implemented, the step will fail, since the students will
be retrieved in the order created.  You can fix by adding
`.order(:last_name)` to the query in the controller method, or (not so
good) by sorting the list in Ruby.
