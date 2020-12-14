quiz "11.4: Open/Closed Principle" do
	choice_answer do
		text "OmniAuth defines a handful of RESTful endpoints your app must provide to handle authentication with a variety of third parties. To add a new auth provider, you create a gem that works with that provider. Which statement is FALSE about OmniAuth?"
		answer "OmniAuth is an example of the Template pattern"
		distractor "OmniAuth is itself compliant with OCP"
		distractor "Using OmniAuth helps your app follow OCP (with respect to 3rd-party authentication)"
		distractor "OmniAuth is an example of the Strategy pattern"
		explanation "From your app's point of view, the API to authentication is just a few URL endpoints, but the process by which it's done varies wildly depending on the auth provider. Some are OAuth, some implement proprietary protocols, some aren't authentication protocols at all but just testing stubs. So OmniAuth is more like Strategy, since it doesn't consist of overriding a fixed sequence of steps that are basically the same for all authentication providers."
	end
end