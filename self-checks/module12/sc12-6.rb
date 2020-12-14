quiz "12.6: Improving Rendering and Database Performance With Caching" do
	choice_answer do
		text "Under-17 visitors to RottenPotatoes shouldn’t see NC-17 movies in any listing. A controller filter exists that can determine if a user is under 17. What kinds of caching would be appropriate when implementing this:
i. Page
ii. Action
iii. Fragment"
		answer "ii. and iii."
		distractor "i. and iii."
		distractor "iii. only"
		distractor "i., ii., and iii."
		explanation "Page caching will bypass the controller filter, but action caching would allow us to avoid regenerating an 'under-17-specific' view of the listings page, and fragment caching could help if we miss in the action cache."
	end
end