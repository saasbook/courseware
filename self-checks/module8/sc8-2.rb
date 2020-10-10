quiz "8.2: Anatomy of a Test Case: Arrange, Act, Assert" do
	choice_answer do
		text "Which of these, if any, is not a valid expectation?"
		answer "expect(5).to be <=> result"
		distractor "expect(result).not_to be_empty"
		distractor "expect(result).to match /^D’oh!$/"
		distractor "All of the above are valid expectations"
		explanation "An explanation is like an assertion, in that it checks whether something is strictly true or false. “expect(5).to be <=> result” is a comparison expression that evaluates to -1, 0, or 1, instead of true or false."
	end
end