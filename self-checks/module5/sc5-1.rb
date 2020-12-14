quiz "5.1: DRYing Out MVC: Partials, Validations and Filters" do
	choice_answer do
		text "Which Ruby language features support the DRYness enabled by validations and filters:
(a) higher-order functions
(b) closures
(c) metaprogramming"
		answer "(a), (b) and (c)"
		distractor "Only (a)"
		distractor "Only (a) and (b)"
		distractor "Only (a) and (c)"
		explanation "Metaprogramming comes into play in that we can provide the name of a validation method as a symbol or string and have Rails resolve and call the actual method at runtime. In validations where we provide an inline lambda-expression, as in validates_presence_of :rating, :if => { self.release_date.year > @ratings_history_date }, higher-order functions are used (we are essentially passing an anonymous function with :if) along with closures (the values of variables such as @ratings_history in the lambda-expression will be the values in scope in the place where the lambda-expression is first defined, even though that place is far away from where it will be called)."
	end
end