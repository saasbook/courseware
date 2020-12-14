quiz "11.7: Demeter Principle" do
	choice_answer do
		text "Suppose Order belongs to Customer, and a view has @order.customer.name. Is this a Demeter violation?"
		answer "Yes...you can make a case for either of the above"
		distractor "Yes...but probably reasonable to just expose object graph in the view in this case"
		distractor "Yes...replace with Order#customer_name which delegates to Customer#name"
		distractor "No...by using belongs_to we're already exposing info about the Customer anyway"
		explanation "A view is about showing information about the models, so it's not unusual for a view to be somewhat coupled to its models and be able to display a representation of the 'object graph'. On the other hand, purists could indeed create a delegate to handle this, and we could hardly disagree with that. So technically it is a Demeter violation, but reasonable people could make a case for either a non-fix or a delegate fix."
	end
end