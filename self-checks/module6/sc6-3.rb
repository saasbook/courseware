quiz "6.3: Classes, Functions and Constructors" do
	choice_answer do
		text "Which call will evaluate to 9?"
		answer "var p=Square; (new p(3)).area()"
		distractor "Square(3).area"
		distractor "Square(3).area()"
		distractor "(new Square(3)).area"
		explanation "This works because “p” just refers to the same function object as “Square”, so we can call this 'constructor-style' function using “new” and then call the 'instance method' “area()” on it."
	end
end