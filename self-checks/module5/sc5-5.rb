quiz "5.5: Through-Associations" do
	choice_answer do
		text "Which of these, if any, is NOT a correct way of saving a new association, given m is an existing movie:"
		answer "All will work"
		distractor "Review.create!(:movie_id=>m.id, :potatoes=>5)"
		distractor "r = m.reviews.build(:potatoes => 5)
r.save!"
		distractor "m.reviews << Review.new(:potatoes=>5)
m.save!"
		explanation "The invariant is that the movie_id attribute must be filled in when the review is created. All the choices accomplish this. The first option does it by explicitly setting the attribute value on create. The second uses the build method, which is provided by the Associations module as a way to create a new instance of an owned object that has the owning object's primary key already filled in as the foreign key; Rails can deduce the foreign key column name (movie_id) and the ID of the owning object because the owning object is the receiver of build. Similarly, when associations are used, << is redefined to "fill in" the foreign key on the newly-created owned object before it is added to the "collection" owned by the owning object. As an aside, note that in the third case, saving an owning object has the side effect of saving its owned objects---even if the owning object itself isn't changed by adding more owned objects to it (as is the case here)."
	end
end