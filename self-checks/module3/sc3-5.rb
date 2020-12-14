quiz "3.5: RESTful APIs: Everything is a Resource" do
	choice_answer do
		text "In the (fictitious) API documentation for `GET /books/:book_id?format=long` which arguments are required?"
		answer "book_id is required, but can’t tell if format is required without looking at API docs"
		distractor "book_id and format are both required"
		distractor "book_id is required, format is optional"
		distractor "Both are optional"
		distractor "Can’t say anything about either one without looking at the API docs"
		explanation "We can tell book_id is necessary because the route would be incomplete without it. However, there’s no way to tell whether format is needed based on the route format alone."
	end
end