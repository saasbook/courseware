quiz "4.6: Forms" do
	choice_answer do
		text "Which of these would be valid Haml for generating the form that, when submitted, would call the Create New Movie action?"
		answer "All of the above"
		distractor "= form_tag movies_path do ... end"
		distractor "%form{:action => movies_path, :method => :post}"
		distractor "%form{:action => 'movies', :method => 'post'}"
		explanation "All that is required by the browser is a <form> tag with an action attribute whose value is the submission URI and whose method attribute names the HTTP method (GET or POST) for submitting the form. All three versions of the code above would generate a tag with these attributes and values."
	end
end