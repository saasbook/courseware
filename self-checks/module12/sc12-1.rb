quiz "12.1: From Development to Deployment" do
	choice_answer do
		text "Let R = RottenPotatoes app's availability; H = Heroku's availability; C = Internet connection availability; P = Armando's perception of RP availability; Which relationship among these quantities holds?"
		answer "Can’t tell without additional information"
		distractor "P <= C <= H <= R"
		distractor "P >= min (C, H, R)"
		distractor "P <= C <= min(H, R)"
		explanation "If Prof. Fox was accessing the site constantly around-the-clock, you could argue that his perception of availability would be no better than the minimum of C,H,R. But since we don't know how often or when he is accessing it, there's no way to tell. If the site is only down 1 minute per day but that's the only time he tries to access it, his perception will be 0% availability, and so on. This is one reason availability is more subtle to quantify than you might expect. SubmitSome problems have options such as save, reset, hints, or show answer. These options follow the Submit button."
	end
end