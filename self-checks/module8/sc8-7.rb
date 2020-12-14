quiz "8.7: Coverage Concepts and Types of Tests" do
	choice_answer do
		text "Which of these is POOR advice for TDD?"
		answer "Unit tests give you higher confidence of system correctness than integration tests"
		distractor "Mock and stub early and often in unit tests"
		distractor "Aim for high unit test coverage"
		distractor "Sometimes it’s OK to use stubs and mocks in integration tests"
		explanation "More unit tests and more test coverage in general is correct, but it doesn’t necessarily translate to more system correctness. Recall that unit tests target functionality at very technical levels (does this method work as intended). Integration tests are much more comprehensive and test several software modules altogether as a group. Therefore, it reflects system correctness more accurately."
	end
end