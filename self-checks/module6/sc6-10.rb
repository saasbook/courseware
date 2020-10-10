quiz "6.10: Single-Page Apps and JSON APIs" do
	choice_answer do
		text "Which, if any, of the following statements are TRUE regarding JSON objects in Rails apps?"
		answer "None of the above are true"
		distractor "A JSON object's properties must exactly match the corresponding ActiveRecord model"
		distractor "In an association such as Movie has-many Reviews, the owned objects must be returned in 1 or more separate JSON object"
		distractor "JSON objects can only be consumed by a JavaScript-capable client"
		explanation "The default behavior of to_json for ActiveRecord models is to construct an object whose properties exactly match the model attributes, but you can always add your own extra fields to the object and/or override the definition of to_json. You could override to_json for your model and explicitly include all the owned objects nested in the owning object. Every major language has JSON parsing libraries. While JSON is particularly easy for a JavaScript client (such as code running a browser) to consume, non-JavaScript code can easily consume JSON objects by using a parsing library."
	end
end