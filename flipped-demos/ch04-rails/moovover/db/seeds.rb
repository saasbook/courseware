# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Movie.delete_all
Movie.create!(:title => 'Lost In Translation', :rating => 'R', :release_date => '2003-09-12')
Movie.create!(:title => 'Coco', :rating => 'PG', :release_date => 'Nov 22, 2017')
Movie.create!(:title => 'The Big Lebowski', :rating => 'PG', :release_date => '06 Mar 1998')
Movie.create!(:title => 'The Help', :rating => 'PG-13', :release_date => 'Aug 10, 2011')

