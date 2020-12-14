quiz "12.4: Releases and Feature Flags" do
	choice_answer do
		text "Which one, if any, is a POOR place to store the value (eg true/false) of a feature flag?"
		answer "A YAML file in config/ directory of app"
		distractor "A column in an existing database table"
		distractor "A separate database table"
		distractor "These are all good places to store feature-flag values"
		explanation "If stored in a file, we need logic to determine if the file has changed and when it can be re-read, so that the feature flag value can be changed without restarting the app and re-reading all the config files. In contrast, database-stored values can be changed at runtime and the new values will be picked up immediately by the app."
	end
end