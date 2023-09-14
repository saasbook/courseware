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

