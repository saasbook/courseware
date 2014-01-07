class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date
end
