quiz "5.7: Composing Queries with Reusable Scopes" do
	choice_answer do
		text "Where do database queries happen?"
		answer "Lines 6-7 only"
		distractor "Line 3 only"
		distractor "Line 3 AND lines 6-7"
		distractor "Depends on return value of for_kids"
		explanation "The first time a value is consumed is somewhere in lines 6-7 in the view, so that's where the query happens. (Technically we could narrow it down further by investigating the implementation of each on the association proxy object represented by @m; you can't tell without looking at the Rails source code if the first value is consumed immediately inside the each, which would imply the query happens at line 6, or if the first value is only 'consumed' when yield has to provide it, which would imply the query happens at line 7.)"
	end
end