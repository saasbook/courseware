quiz "6.8: Testing JavaScript and AJAX" do
	choice_answer do
		text "Which are always true of Jasmine's it() method:
a. it can take a named function as its 2nd argument
b. it can take an anonymous function as its 2nd argument
c. it executes asynchronously"
		answer "(a) and (b)"
		distractor "(a) and (c)"
		distractor "(b) and (c)"
		distractor "All are true"
		explanation "Since functions are first-class in JavaScript, there is no syntactic distinction between providing an anonymous function or the name of an existing function. Since JavaScript is single-threaded, all code including Jasmine tests execute synchronously."
	end
end