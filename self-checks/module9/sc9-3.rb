quiz "9.3: Establishing Ground Truth with Characterization Tests" do
	choice_answer do
		text "Which is FALSE about integration-level characterization tests vs. module- or unit-level characterization tests?"
		answer "They are based on fewer assumptions about how the code works"
		distractor "They are just as likely to be unexpectedly dependent on the production database"
		distractor "They rely less on detailed knowledge about the code’s structure"
		distractor "If a customer can do the action, you can create a simple characterization test by mechanizing the action by brute force"
		explanation "High-level behaviors captured as black-box tests may indeed be making assumptions about the code, even if those assumptions aren't obvious. For example, the site may behave differently on holidays, or behave differently depending on the amount of data in the database or how many users are logged in."
	end
end