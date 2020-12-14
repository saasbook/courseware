quiz "6.6: Events and Callbacks" do
	choice_answer do
		text "If this form is loaded in a non-JS-aware browser:"
		answer "The form will be submitted, but without inputs being checked"
		distractor "Browser will complain about malformed HTML when page is loaded (server should respect browser version and not send JavaScript)"
		distractor "Browser will complain, but only when form's Submit button clicked"
		distractor "Nothing will happen when submit button is clicked (form won't be submitted)"
		explanation "The JavaScript-specific content will simply be ignored, in this case the specification of a handler for the form's submit event, and the form will behave just as if JavaScript didn't exist."
	end
end