quiz "2.3: Introducing Ruby, an Object-Oriented Language" do
	choice_answer do
		text "Which ones are correct:
(a) my_account.@balance
(b) my_account.balance
(c) my_account.balance()"
		answer "(b) and (c)"
		distractor "All Three"
		distractor "Only (b)"
		distractor "(a) and (b)"
		explanation "In Ruby, the @ symbol is used to specify a field within the definition of a class. However, when it comes to dereferencing a field of an object of that class, we use dot notation, not the @ symbol. The reason both b and c are correct is that, as you may recall, everything in Ruby is an object."
	end
end