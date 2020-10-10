quiz "11.2: Just Enough UML" do
	choice_answer do
		text "Which ActiveRecord association would NOT appear in a Rails app that follows this simplified UML class diagram?"
		answer "Item has one AccountCode"
		distractor "Show has many Vouchers, through Showdate "
		distractor "Customer has many Donations"
		distractor "Voucher belongs to Vouchertype"
		explanation "It is true that a given Item has only a single AccountCode, but has-one is a 1-to-1 relationship, and the diagram shows that an AccountCode has many Items. So the relationship expressed here is Item belongs to AccountCode and AccountCode has many Items."
	end
end