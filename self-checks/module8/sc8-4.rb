quiz "8.4: Stubbing the Internet" do
	choice_answer do
		text "to_receive combines _____ and _____, whereas stub is only _____."
		answer "A seam and an expectation, a seam"
		distractor "A mock and an expectation, a mock"
		distractor "A mock and an expectation, an expectation"
		distractor "A seam and an expectation, an expectation"
		explanation "Recall that seams help you isolate the behavior of an application and change it without having to change the code, while an expectation is similar to the idea of an assertion that indicates what about the nature of an application should be true."
	end
end