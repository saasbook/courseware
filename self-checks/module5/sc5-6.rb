quiz "5.6: RESTful Routes for Associations" do
	choice_answer do
		text "If we also have moviegoer has_many reviews, can we use moviegoer_review_path() as a helper?"
		answer "Yes, but we must declare reviews as a nested resource of moviegoers in routes.rb"
		distractor "Yes, it should work as-is because of convention over configuration"
		distractor "No, because there can be only one RESTful route to any particular resource"
		distractor "No, because having more than one through-association involving Reviews would lead to ambiguity"
		explanation "This will work, but we need to be explicit about what we want in routes.rb. The reason is that the concept of the association is separate from the concept of how to construct routes for it: in some cases we might want a route that gets us to a review by "traversing" the movie that owns it, in other cases we might want to get to a review by "traversing" the moviegoer that wrote it, but in either case the underlying association is the same--what's different is how we choose to represent it in a route."
	end
end