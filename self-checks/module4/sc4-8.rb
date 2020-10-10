quiz "4.8: Debugging: When Things Go Wrong" do
	choice_answer do
		text "If you use puts or printf to print debugging messages in a production app:"
		answer "Your app will continue, but the messages will be lost forever"
		distractor "Your app will raise an exception and grind to a halt"
		distractor "Your app will continue, and the messages will go into the log file"
		distractor "The SaaS gods will strike you down in a fit of rage"
		explanation "The built in “puts”, similar to “print” in Python and “println” in Java, shows messages in the standard output. However, when an app is running in production, there is no viewable standard output, so “puts” outputs will not be recorded."
	end
end