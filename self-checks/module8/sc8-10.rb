quiz "8.10: The Plan-And-Document Perspective on Testing" do
	choice_answer do
		text "Which statement regarding testing is FALSE?"
		answer "Formal methods are expensive but worthwhile to verify important applications"
		distractor "PandD developers code before they write tests while its vice versa after"
		distractor "Agile developers Agile developers perform module, integration, system, and acceptance tests. PandD developers don’t"
		distractor "PandD sandwich integration aims to reduce wasted work making stubs while trying to get general functionality early"
		explanation "Recall that formal methods use mathematical proofs to verify whether applications are performing correctly. These methods are indeed expensive, and while helpful, they are not worthwhile for verifying application correctness because of 1. How time and labor intensive developing formal methods are and 2. They must be updated as the application changes, which is not feasible in an Agile environment."
	end
end