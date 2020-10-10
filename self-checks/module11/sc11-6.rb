quiz "11.6: Injection of Dependencies Principle" do
	choice_answer do
		text "In RSpec controller tests, it's common to stub ActiveRecord::Base.where, an inherited method. Which statements are true of such tests:
a. The controller under test is tightly coupled to the model
b. In a static language, we'd have to use DI to achieve the same task in the testing framework."
		answer "both (a) and (b)"
		distractor "only (a)"
		distractor "only (b)"
		distractor "neither (a) and (b)"
		explanation "a. The controller is calling where directly, suggesting that it has detailed knowledge of the database schema for the model.
b. Injecting a dependency would allow whichever method is called to be replaced at testing time with a double."
	end
end