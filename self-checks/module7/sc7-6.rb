quiz "7.6: Cucumber: From User Stories to Acceptance Tests" do
	choice_answer do
		text "Which is FALSE about Cucumber and Capybara?"
		answer "Step definitions are in Ruby, and are similar to method calls, while steps are in English and are similar to method definitions"
		distractor "A Feature has one or more Scenarios, which are composed typically of 3 to 8 Steps"
		distractor "Steps use Given for current state, When for actions, and Then for consequences of actions "
		distractor "Cucumber matches step definitions to scenario steps using regexes, and Capybara pretends to be user that interacts with SaaS app accordingly"
		explanation "The statement is almost correct, except step definitions are  more similar to method definitions (not calls), while steps are more similar to method calls (not definitions)"
	end
end