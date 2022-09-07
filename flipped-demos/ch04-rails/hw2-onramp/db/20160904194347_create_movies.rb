class CreateMovies < ActiveRecord::Migration[5.0]
  def change
    create_table :movies do |t|
    	t.string 'title'
    	t.string 'rating'
    	t.text 'description'
    	t.datetime 'release_date'
    	#Add fields that let Rails automatically keep track
    	#of when movies are added or modified:
    	t.timestamps
    end
  end
end
