quiz "6.7: AJAX: Asynchronous JavaScript And XML" do
	choice_answer do
		text "Which is FALSE concerning AJAX/XHR vs. non-AJAX interactions?"
		answer "If the server fails to respond to an XHR request, the browser's UI will freeze"
		distractor "AJAX requests can be handled with their own separate controller actions"
		distractor "In general, the server must rely on explicit hint (like headers) to detect XHR"
		distractor "The response to an AJAX request can be any content type (not just HTML)"
		explanation "Although JavaScript is single-threaded, XHR is asynchronous--it returns as soon as the XHR request is queued to send--so it will not block the UI. However, the callback that would be triggered by the server response will never get called if the server doesn't send back any data, so from the user's point of view, it will appear that she took some action but nothing happened."
	end
end