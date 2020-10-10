quiz "8.8: Other Testing Approaches and Terminology" do
	choice_answer do
		text "Which non-obvious statement about testing is FALSE?"
		answer "Testing eliminates the need to use a debugger"
		distractor "Even 100% test coverage is not a guarantee of being bug-free"
		distractor "If you can stimulate a bug-causing condition in a debugger, you can capture it in a test"
		distractor "When you change your code, you need to change your tests as well"
		explanation "Recall that even 100% test coverage doesn’t mean code is bug free, whether it is with regards to the technical implementation or overall system correctness according to the customer behavior. Therefore, using a debugger is still needed to trace errant behavior that may not be covered by an existing test, or perhaps cannot be written as a test (non-deterministic errors)."
	end
end