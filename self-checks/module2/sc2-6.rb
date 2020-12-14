quiz "2.6: Gems and Bundler: Library Management in Ruby" do
	choice_answer do
		text "Which of the library-management files in a Rails app should be versioned?"
		answer "Both Gemfile and Gemfile.lock"
		distractor "Only Gemfile"
		distractor "Only Gemfile.lock"
		distractor "Neither Gemfile nor Gemfile.lock"
		explanation "When deciding what files should be recorded in version control, keep in mind that the top priority is to reduce variability as much as possible. The Gemfile lists the required dependencies, but the Gemfile.lock specifies the specific versions of each dependency that is in use. Therefore, to avoid version conflicts, committing both the Gemfile and Gemfile.lock is recommended."
	end
end