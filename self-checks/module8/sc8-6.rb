quiz "8.6: Fixtures and Factories" do
	choice_answer do
		text "Which of the following kinds of data, if any, should not be set up as fixtures?"
		answer "Movies and their ratings"
		distractor "The TMDb API key"
		distractor "The application's time zone"
		distractor "Fixtures would be fine for all of these"
		explanation "Recall that the definition of a fixture is a fixed state that is used as a baseline for running tests in software testing. Therefore, it’d be best to set up any data that is not dependent on the user’s configurations as fixtures. In this case, movies and their ratings can be divulged to other developers, but users may have their own unique API key and live in different time zones."
	end
end