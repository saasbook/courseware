quiz "7.1: Behavior-Driven Design and User Stories" do
	choice_answer do
		text "User Story 1:
See which of my friends are going to a show
- As a theatergoer
- So that I can enjoy the show with my friends
- I want to see which of my Facebook friends are attending a given show

User Story 2:
Show patron’s Facebook friends
- As a box office manager
- So that I can induce a patron to buy a ticket
- I want to show her which of her Facebook friends are going to a given show"
		answer "This should be left as 2 stories because the functionality and user experience may be different, & both may be important."
		distractor "This should be consolidated into a single user story from the patron’s point of view"
		distractor "This should be consolidated into a single user story from the manager’s point of view"
		explanation "The goal of user stories is for customers and developers to agree on what is important. If there are stories that might seem similar, but address value from two different points of view, it is better to leave the stories separate to reflect what the customer wants for their business. Ultimately, it’s not up to developers to merge these stories without discussing with the customer."
	end
end