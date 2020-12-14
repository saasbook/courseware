quiz "11.5: Liskov Substitution Principle" do
	choice_answer do
		text "(a) In duck-typed languages, LSP violations can occur even when inheritance is not used
(b) In statically-typed languages, if the compiler reports no type errors/warnings, then there are no LSP violations"
		answer "Only (a) is true"
		distractor "Only (b) is true"
		distractor "Both are true"
		distractor "Both are false"
		explanation "(a) is true: For example, in Ruby, you might mix in the Comparable module but define <=> in a way that doesn't obey the triangle inequality. Even though there is no inheritance here, you've violated the contract expected by the mixed-in module.
(b) is false: The Square/Rectangle example explained in the lecture (and at http://pastebin.com/nf2D9RYj) would pass static type checks, yet it violates LSP."
	end
end