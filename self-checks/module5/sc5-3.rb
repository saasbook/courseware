quiz "5.3: Single Sign-On and Third-Party Authentication" do
	choice_answer do
		text "Which is true about third-party authentication between a requester and a provider?"
		distractor "Once completed, the requester can do anything you can do on the provider"
		distractor "If your credentials on the requester are compromised, your credentials on the provider are also compromised"
		distractor "If the provider revokes access, the requester no longer has any of your info"
		answer "Access can be time-limited to expire on a pre-set date"
		explanation "Most third-party authentication schemes support expiration, to limit the damage in case the requester is compromised."
	end
end