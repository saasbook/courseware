quiz "1.9: Beautiful vs. Legacy Code" do
	choice_answer do
		text "Which are TRUE regarding refactoring?"
		answer "It often results in changes to the test suite "
		distractor "It usually results in fewer total lines of code"
		distractor "It should not cause existing tests to fail"
		distractor "It addresses explicit (vs. implicit) customer requirements"
		explanation "Refactoring code may often result in more lines, especially if debugging or writing more comprehensible code is involved. Refactoring sometimes addresses customer requirements, but that is not the only reason for it. Refactoring usually results in changes that are propagated and reflected by updates to the testing suite."
	end
end