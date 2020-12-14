quiz "10.2: Using Branches Effectively" do
	choice_answer do
		text "If separate sub-teams are assigned to work on release bug fixes and new features, you will need to use:"
		answer "Branch per release + Branch per feature"
		distractor "Branch per release"
		distractor "Branch per feature"
		distractor "Any of these will work"
		explanation "Branch per release allows the release team to apply "hot fixes" to the released version even if the trunk or master branch has diverged from the released version. Branch per feature allows new feature development without interfering with the trunk or with deployed releases."
	end
end