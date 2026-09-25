# Module 10 Self-Checks

**Self-Check 10.1: It Takes a Team: Two-Pizza and Scrum**

Which expression statement regarding SCRUM is TRUE?

(x) Scrum is at its best when it is difficult to plan ahead
( ) Scrum is good for safety critical software as well as SaaS
( ) Scrum implies Agile software development practices like TDD
( ) All of these statements are true

[[Agile and Scrum are a good match, but the two do not have to be used together. Scrum is not entirely sufficient for safety critical software, as there may be additional tools (formal methods, verification) that can better validate safety critical software.]]

---

**Self-Check 10.2: Using Branches Effectively**

If separate sub-teams are assigned to work on release bug fixes and new features, you will need to use:

(x) Branch per release + Branch per feature
( ) Branch per release
( ) Branch per feature
( ) Any of these will work

[[Branch per release allows the release team to apply "hot fixes" to the released version even if the trunk or master branch has diverged from the released version. Branch per feature allows new feature development without interfering with the trunk or with deployed releases.]]

---

**Self-Check 10.3: Pull Requests and Code Reviews**

If you try to push to a remote and get a “non-fast-forward (error): failed to push some refs”, which statement is FALSE?

(x) You need to manually fix merge conflicts in one or more files
( ) Some commits present at remote are not present on your local repo
( ) You need to do a merge/pull before you can complete the push
( ) Your local repo is out-of-date with respect to the remote

[[The commits present on the remote but absent from your copy may or may not cause conflicts in individual files. In a well-organized project, unexpected per-file conflicts should be rare.]]

---

**Self-Check 10.4: Delivering the Backlog Using Continuous Integration**

RottenPotatoes just got some new AJAX features. Where does it make sense to test these features?

(x) All of these answers are correct
( ) Using autotest with RSpec+Cucumber
( ) In CI
( ) In the staging environment

[[We shouldn't rely on just one kind of test. These features could be tested for basic correctness in development, stress-tested in staging, and cross-browser-tested in CI.]]

---

**Self-Check 10.6: Reporting and Fixing Bugs: The Five R's**

Suppose you discover that your most recent release contains a bug whose regression test will require extensive mocking or stubbing because the buggy code is convoluted. Which action, if any, is NOT appropriate?

(x) Do the refactoring using TDD on the release branch, and push the bug fix as new code with tests
( ) Do the refactoring using TDD on a different branch, push the bug fix as new code with tests, then cherry-pick the fix into release
( ) Create a regression test with the necessary mocks and stubs, painful though it may be, and push the bugfix and tests to release branch
( ) Depending on project priorities and project management, any of these might be appropriate

[[Never do development or make changes directly on the release branch. Remember: always mount a scratch monkey.]]

---

**Self-Check 10.7: The Plan-And-Document Perspective on Managing Teams**

Which expression statement regarding Reviews and Meetings is FALSE?

(x) The A’s in SAMOSA stands for Agenda and Action items, which are optional pieces of good meetings
( ) Intended to improve the quality of the software product using the wisdom of the attendees
( ) They result in technical information exchange and can be highly educational for junior people
( ) Can be beneficial to both presenters and attendees

[[As described in the answer choices]]
