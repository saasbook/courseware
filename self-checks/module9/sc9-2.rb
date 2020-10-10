quiz "9.2: Exploring a Legacy Codebase" do
	choice_answer do
		text ""Patrons can make donations as well as buying tickets. For donations we need to track which fund they donate to so we can create reports showing each fund's activity. For tickets, we need to track what show they're for so we can run reports by show, plus other things that don't apply to donations, such as when they expire."
Which statement is LEAST compelling for this design?"
		answer "Donations and Tickets should subclass from a common ancestor."
		distractor "Donation has at least 2 collaborator classes."
		distractor "Donations and Tickets should implement a common interface such as “Purchasable”."
		distractor "Donations and Tickets should implement a common interface such as “Reportable”."
		explanation "Donations and tickets seem to differ at least as much as they are similar, since donations do not expire and tickets do not have an associated fund. It seems tempting to use inheritance, but it\'s not clear that\'s a good solution in this case."
	end
end