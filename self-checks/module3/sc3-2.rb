quiz "3.2: SaaS Communication Uses HTTP Routes" do
	choice_answer do
		text "Which statement is true about the two HTTP requests:
GET /foo/bar
POST /foo/bar"
		answer "They are distinguishable and may have different behaviors"
		distractor "They are indistinguishable to a SaaS app"
		distractor "They are distinguishable and must have different behaviors"
		distractor "A given app can handle one or the other, but not both"
		explanation "The are distinguishable because of the different HTTP request types (GET vs. POST), and they don’t have to have different behaviors, because a method can be defined to accept and handle routes that might have different request types."
	end
end