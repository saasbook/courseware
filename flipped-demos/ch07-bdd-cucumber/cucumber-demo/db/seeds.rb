# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Student.delete_all
%w(Armando Fox Michael Ball Tim Aveni Yu Long Fernanda Pisconte Guobin Liang).each_slice(2) do |first,last|
  Student.create!(:sid_number => 9999+rand(1000), :first_name => first, :last_name => last)
end
