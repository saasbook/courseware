quiz "12.9: Security: Defending Customer Data in Your App" do
	choice_answer do
		text "If a site has a valid SSL certificate from a trusted CA, which of the following are true:
i) The site is probably not “masquerading” as an impostor of a real site
ii) CSRF + SQL injection are harder to mount against it
iii) Your data is secure once it reaches the site"
		answer "(i) only"
		distractor "(i) and (ii) only"
		distractor "(ii) and (iii) only"
		distractor "(i), (ii) & (iii)"
		explanation "SSL assures the server's identity (if the certificate is from a trusted signing authority) and protects data while in transit to the server, but that's it."
	end
end