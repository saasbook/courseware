quiz "4.2: Rails Models: Databases and Active Record" do
	choice_answer do
		text "Which statement is NOT true about the Model in Model--View--Controller:"
		answer "The CRUD actions only apply to models backed by a database that supports ActiveRecord."
		distractor "Part of the Model's job is to convert between in-memory and stored representations of objects."
		distractor "Although model data is displayed by the View, a Model's direct interaction is with Controllers."
		distractor "Although DataMapper doesn't use relational databases, it's a valid way to implement a Model."
		explanation "Recall that the MVC design pattern focuses on dividing program logic, and is not as concerned with the technical disparities within the implementations themselves, such as differences among languages and platforms. Therefore, the database doesn’t necessarily need to support ActiveRecord."
	end
end