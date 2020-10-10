quiz "11.3: Single Responsibility Principle" do
	choice_answer do
		text "Which is true about a class's observance of the Single Responsibility Principle?"
		answer "Low cohesion is a possible indicator of an opportunity to extract a class"
		distractor "In general, we would expect to see a correlation between poor cohesion score and poor SOFA metrics"
		distractor "If a class respects SRP, its methods probably respect SOFA"
		distractor "If a class's methods respect SOFA, the class probably respects SRP"
		explanation "While good style and freedom from smells are important at both the method and class level, they are largely orthogonal. A class with too many responsibilities could have lots of small methods that all follow SOFA, and a class with one responsibility might implement that responsibility with methods that run afoul of SOFA."
	end
end