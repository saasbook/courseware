quiz "10.7: Reporting and Fixing Bugs: The Five R's" do
	choice_answer do
		text "Suppose you discover that your most recent release contains a bug whose regression test will require extensive mocking or stubbing because the buggy code is convoluted. Which action, if any, is NOT appropriate?"
		answer "Do the refactoring using TDD on the release branch, and push the bug fix as new code with tests "
		distractor "Do the refactoring using TDD on a different branch, push the bug fix as new code with tests, then cherry-pick the fix into release"
		distractor "Create a regression test with the necessary mocks and stubs, painful though it may be, and push the bugfix and tests to release branch"
		distractor "Depending on project priorities and project management, any of the above might be appropriate"
		explanation "Never do development or make changes directly on the release branch. Remember: always mount a scratch monkey."
	end
end