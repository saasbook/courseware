# README

This mini-app was created with Ruby 2.7, Rails 6.1, and this command
line:

`rails new moovover --skip-test --skip-turbolinks --skip-jbuilder --skip-active-job --skip-webpack-install --skip-git --skip-keep --minimal`

Say `rails help new` to understand what the various options do.

Then follow this with:

`rails scaffold movie title:string rating:string release_date:date`

This generates a migration you can apply with `rake db:migrate`.  For
clarity I removed `t.timestamps` from the migration. 

Finally, add `resources :movies` to `config/routes.rb`.

Seed data is provided in `db/seeds.rb` that you can load with `rake db:seed`.

# Suggested demo script

## Demo: find

* Movie.all ; then show using pp ; then show finding by id, and finding by .first
* What does this object look like? What do its getters and setters do?
* Show Movie.where, result quacks like an enumerable
* chaining .where
* change attributes, but show that reloading object doesn’t see changes
* then #save

## Demo: create

* Create via #new, assign attributes
* #save
* Create via #create with inline literal attributes

## Demo: update & delete

* Grab an object
* #update({hash}) - saves in place
* #destroy
* can’t modify destroyed object in memory: how implemented?

## Demo: form

* Get a couple of errors (Rails landing page, bad route) dealing w/app.
* Create new movie = 2 actions. Remember which 2?
* Key idea: form is based on resource, so form fields should be resource attrs. 
* Show Rails form code and HTML form code 
* What is the route that we should submit to?  How did Rails populate the `<form>` tag?  (from `form_with`, it knows the resource's class, and uses the routes info to figure out the RESTful Create controller and action pair)
* Stop in controller w/debugger and inspect params, compare to form field names

## Demo: form, contd

* Step into strong-params helper method, show that return value has "permitted: true"
* Then proceed with creation



