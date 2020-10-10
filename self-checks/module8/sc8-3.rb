quiz "8.3: Isolating Code: Doubles and Seams" do
	choice_answer do
		text "Which is FALSE about expect(...).to receive?"
		answer "It can be issued either before or after the code that should make the call"
		distractor "It provides a stand-in for a real method that doesn’t exist yet"
		distractor "It would override the real method, even if it did exist"
		distractor "It exploits Ruby’s open classes and metaprogramming to "intercept" a method call at testing time"
		explanation "The expect(...).to receive matcher clause must be issued after the code making the call, as it serves as an assertion that certain effects were caused by the method calls."
	end
end