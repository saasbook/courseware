quiz "8.1: FIRST, TDD, and Red–Green–Refactor" do
	choice_answer do
		text "Which kinds of code can be tested Repeatably and Independently?
i. Code that relies on randomness (e.g. shuffling a deck of cards)
ii. Code that relies on time of day (e.g. run backups every Sunday at midnight)"
		answer "Both"
		distractor "Only (i)"
		distractor "Only (ii)"
		distractor "Neither"
		explanation "With randomness, we can test repeatably by using a random number seed that fixes the order of random numbers from a generator. For the time of day, we can use an approach called “stubbing” that can help us define a mock context that allows code to run."
	end
end