quiz "1.6: SaaS and Service Oriented Architecture" do
	choice_answer do
		text "The inability of one service to directly access another service's data is a characteristic of:"
		answer "Service-oriented architecture"
		distractor "The Rails framework"
		distractor "Object-oriented programming"
		distractor "Agile development"
		explanation "The trademark of service oriented architecture is that services are self contained, and how it works is a black box to the user or data being submitted to it. As a result, the service should not be able to directly access another service in an SOA setting, as that would imply that the service accessing the other service’s data directly knows its inner workings."
	end
end