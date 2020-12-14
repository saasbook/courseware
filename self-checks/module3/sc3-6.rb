quiz "3.6: RESTful URIs, Operations, and JSON" do
	choice_answer do
		text "Below are possible routes for manipulating Movie resources. The R, I, and C stand for Read, Insert, and Create (recall the CRUDI acronym detailing basic functions for persistent storage)
	- R: GET /movies/253
	- I: GET /movies?name=hidden+figures
	- C: POST /movies
While the "Read" and "Insert" routes have an ID of some form (253, hidden figures), why does the "Create" route  have an ID?"
		answer "It will be carried in POST request body, along with data about the new movie"
		distractor "The movie hasn’t been created yet, so it doesn’t have an ID"
		distractor "The route is incomplete: it should be something like “POST /movies/:movie_id”"
		explanation "Often times, the information that accompanies the POST request is sent as a JSON file (we will discuss this further in later sections) instead of being placed in the URI itself. This improves readability of the URI, and sending data as a JSON is typically easier than being written into a URI."
	end
end