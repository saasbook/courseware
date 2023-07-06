require 'active_support/core_ext/hash'

class Movie
  attr_accessor :title, :rating, :description, :release_date
  def initialize(title, rating, description, release_date)
    @title,@rating,@description,@release_date =
      title,rating,description,release_date
  end
  def attributes_hash
    {'title' => @title,
      'rating' => @rating,
      'description' => @description,
      'release_date' => @release_date.strftime('%F')
    }
  end
  def as_json
    JSON.pretty_generate(attributes_hash)
  end
  def as_xml
    attributes_hash.to_xml(:root => 'movie')
  end
end
end

hf = Movie.new('Hidden Figures', 'PG',
  'The story of a team of female African-American mathematicians who served a vital role in NASA during the early years of the U.S. space program.',
  Time.new(2017, 1, 6))

puts hf.as_json

puts hf.as_xml
