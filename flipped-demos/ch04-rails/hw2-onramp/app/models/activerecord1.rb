#require 'movies'

class ActiveRecord1
	####  Create
	starwars = Movie.create!(:title => 'Star Wars',
	  :release_date => '25/4/1977', :rating => 'PG')
	# note that numerical dates follow European format: dd/mm/yyyy
	requiem =  Movie.create!(:title => 'Requiem for a Dream',
	  :release_date => 'Oct 27, 2000', :rating => 'R')
	#  Creation using separate 'save' method, used when updating existing records
	field = Movie.new(:title => 'Field of Dreams',
	  :release_date => '21-Apr-89', :rating => 'PG')
	field.save!
	field.title = 'New Field of Dreams'
	####  Read
	pg_movies = Movie.where("rating = 'PG'")
	ancient_movies = Movie.where('release_date < :cutoff and rating = :rating',
	  :cutoff => 'Jan 1, 2000', :rating => 'PG')
	####  Another way to read
	Movie.find(3)  # exception if key not found
	####  Update
	starwars.update_attributes(:description => 'The best space western EVER',
	  :release_date => '25/5/1977')
	requiem.rating = 'NC-17'
	requiem.save!
	####  Delete
	requiem.destroy
	Movie.where('title = "Requiem for a Dream"')
	####  Find returns an enumerable
	Movie.where('rating = "PG"').each do |mov|
	  mov.destroy
	end
end