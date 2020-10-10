quiz "6.2: Introducing ECMAScript" do
	choice_answer do
		text "Which is NOT true about functions in JavaScript?"
		answer "They can execute concurrently with other functions"
		distractor "They can be anonymous"
		distractor "They always return a value, even if that value might be undefined"
		distractor "They can be passed a function as an argument"
		explanation "JavaScript is single-threaded so functions execute one at a time. All the other statements are true."
	end
end