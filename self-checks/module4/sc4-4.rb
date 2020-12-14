quiz "4.4: Routes, Controllers, and Views" do
	choice_answer do
		text "Which statement is NOT true regarding Rails RESTful routes and the resources to which they refer?"
		answer "The route always contains one or more 'wildcard' parameters such as :id to identify the particular resource instance used in the operation."
		distractor "A resource may be existing content or a request to modify something."
		distractor "In an MVC app, every route must eventually trigger a controller action."
		distractor "One common set of RESTful actions is the CRUD actions on models."
		explanation "A route does not necessarily need to have a parameter in general. For instance, for a Movies application, a “GET /movies” route could be a valid request, with no parameters, that retrieves an exhaustive list of all movies."
	end
end