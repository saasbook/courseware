class CreateMovies < ActiveRecord::Migration[5.0]
  def up
    create_table :movies do |t|
      t.string :Title
      t.string :Rating
      t.text :Description
      t.datetime :Release_date
      # Add fields that let Rails automatically keep track
      # of when movies are added or modified:
      t.timestamps
    end
  end

  def down
    drop_table :movies
  end
end
