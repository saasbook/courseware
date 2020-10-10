quiz "3.1: The Web's Client–Server Architecture" do
	choice_answer do
		text "Choose the terms that make a true statement: A ____ can create and modify cookies; the ____ is responsible for including the correct cookie with each request."
		answer "SaaS app; browser"
		distractor "Browser; SaaS app"
		distractor "HTTP request; browser"
		distractor "SaaS app; HTTP response"
		explanation "The SaaS app has the responsibility of creating cookies that correspond to running user sessions which hold on to persisted information. The browser checks cookies to verify whether certain requests and operations are allowed."
	end
end