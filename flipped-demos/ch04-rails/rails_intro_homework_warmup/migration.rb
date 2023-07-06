  create_table 'movies', :force => true do |t|
    t.string :title
    t.string :rating
    t.text :description
    t.datetime :release_date
    # Add fields that let Rails automatically keep track
    # of when movies are added or modified:
    t.timestamps
  end
  
