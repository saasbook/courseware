quiz "10.4: Continuous Integration" do
	choice_answer do
		text "RottenPotatoes just got some new AJAX features. Where does it make sense to test these features?"
		answer "All of the above"
		distractor "Using autotest with RSpec+Cucumber"
		distractor "In CI"
		distractor "In the staging environment"
		explanation "We shouldn't rely on just one kind of test. These features could be tested for basic correctness in development, stress-tested in staging, and cross-browser-tested in CI."
	end
end