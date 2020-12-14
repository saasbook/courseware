quiz "12.10: The Plan-And-Document Perspective on Operations" do
	choice_answer do
		text "Which statement regarding reliability and security is most likely FALSE?"
		answer "Not removing data races could violate the security principle of psychological acceptability"
		distractor "Improper initialization of data could violate the security principle of fail-safe defaults"
		distractor "Not checking buffer limits could violate the security principle of least privilege"
		distractor "None are false; all are true"
		explanation "Data races describe an error related to non-determinism caused by two competing processes commonly found in systems (OS, databases, parallel computing). This is not particularly related to psychological acceptability, which refers to a more social set of conditions."
	end
end