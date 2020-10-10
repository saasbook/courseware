quiz "5.4: Associations and Foreign Keys" do
	choice_answer do
		text "Which statement is false regarding Cartesian products as a way of representing relationships?"
		answer "You can only filter based on on primary or foreign key (id) columns"
		distractor "You can represent one-to-one relationships as well as one-to-many relationships"
		distractor "You can represent many-to-many relationships"
		distractor "The size of the full Cartesian product is independent of the join criteria"
		explanation "You can filter on any columns you wish. However, because Rails and other frameworks use filtered Cartesian products specifically as a way to model relationships between model entities, Rails only uses the primary and foreign keys of model tables as filter criteria for joins."
	end
end