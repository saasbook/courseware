quiz "10.3: Pull Requests and Code Reviews" do
	choice_answer do
		text "If you try to push to a remote and get a “non-fast-forward (error): failed to push some refs”, which statement is FALSE?"
		answer "You need to manually fix merge conflicts in one or more files"
		distractor "Some commits present at remote are not present on your local repo"
		distractor "You need to do a merge/pull before you can complete the push"
		distractor "Your local repo is out-of-date with respect to the remote"
		explanation "The commits present on the remote but absent from your copy may or may not cause conflicts in individual files. In a well-organized project, unexpected per-file conflicts should be rare."
	end
end