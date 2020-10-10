quiz "12.7: Avoiding Abusive Database Queries" do
	choice_answer do
		text "Suppose Movie has many Moviegoers through Reviews. Which foreign-key index or indices would MOST help speed up the query: "fans = @movie.moviegoers""
		answer "reviews.movie_id"
		distractor "movies.review_id"
		distractor "reviews.moviegoer_id"
		distractor "moviegoers.review_id"
		explanation "Because of the through-association, the query involves finding the review(s) whose movie_id matches this movie, and then for each of those, looking up the appropriate moviegoer_id. So we need an index on the movie_id field of reviews. We don't need any special index on moviegoers, since lookups by id are already indexed by default."
	end
end