quiz "7.8: Explicit vs. Implicit and Imperative vs. Declarative Scenarios" do
	choice_answer do
		text "Which is TRUE about implicit vs. explicit and declarative vs. imperative scenarios?"
		distractor "Explicit requirements are usually defined with imperative scenarios and implicit requirements are usually defined with declarative scenarios"
		answer "Explicit scenarios are usually captured by integration tests"
		distractor "Declarative scenarios aim to capture implementation as well as behavior"
		distractor "All are false"
		explanation "Explicit scenarios usually capture acceptance tests that reflect user stories discussed with the customer.  NO type of high-level scenario (either implicit or explicit, either declarative or imperative) focuses on implementation; all focus on behavior. Changing the implementation while preserving the external-facing behavior should still allow such scenarios to pass. And either implicit or explicit requirements may be captured with either declarative or imperative scenarios, as appropriate; declarative vs imperative really just defines the granularity of behavior being described in the scenario, but says nothing about the nature of the requirement being exercised by the scenario."
	end
end