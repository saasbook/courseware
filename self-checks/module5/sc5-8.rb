quiz "5.8: Other Types of Code" do
	choice_answer do
		text "To encapsulate queries that touch many different models, what kind of object should be used?"
		answer "Query Object"
		distractor "Policy Object"
		distractor "Service Object"
		distractor "Form Object"
		explanation "As in the name, query objects encapsulate queries that involve multiple models. Policy objects are special cases of service objects that focus on enforcing constraints on multiple models. Form objects process data submissions that require updates to multiple models, while service objects can be thought of as a super class to form, query, and policy objects. They encapsulate any operations that read and write to multiple models, such that it's unnatural to assign the logic as a special case of a single model."
	end
end