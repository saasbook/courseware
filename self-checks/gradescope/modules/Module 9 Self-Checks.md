# Module 9 Self-Checks

**Self-Check 9.1: What Makes Code "Legacy" and How Can Agile Help?**

If you’ve been assigned to modify legacy code, which statement would make you happiest if true?

(x) "It is well covered by tests"
( ) "It was originally developed using Agile techniques"
( ) "It’s nicely structured and easy to read"
( ) "Many of the original design documents are available"

[[If the code is well covered by tests, you can safely refactor it to improve its structure and make changes, even if its original structure is poor and design documents are lacking.]]

---

**Self-Check 9.2: Exploring a Legacy Codebase**

"Patrons can make donations as well as buying tickets. For donations we need to track which fund they donate to so we can create reports showing each fund's activity. For tickets, we need to track what show they're for so we can run reports by show, plus other things that don't apply to donations, such as when they expire."

Which of the following statements is LEAST compelling for this design?

(x) Donations and Tickets should subclass from a common ancestor
( ) Donation has at least 2 collaborator classes
( ) Donations and Tickets should implement a common interface such as “Purchasable”
( ) Donations and Tickets should implement a common interface such as “Reportable”

[[Donations and tickets seem to differ at least as much as they are similar, since donations do not expire and tickets do not have an associated fund. It seems tempting to use inheritance, but it\'s not clear that\'s a good solution in this case.]]

---

**Self-Check 9.3: Establishing Ground Truth with Characterization Tests**

Which is FALSE about integration-level characterization tests vs. module- or unit-level characterization tests?

(x) They are based on fewer assumptions about how the code works
( ) They are just as likely to be unexpectedly dependent on the production database
( ) They rely less on detailed knowledge about the code’s structure
( ) If a customer can do the action, you can create a simple characterization test by mechanizing the action by brute force

[[High-level behaviors captured as black-box tests may indeed be making assumptions about the code, even if those assumptions aren't obvious. For example, the site may behave differently on holidays, or behave differently depending on the amount of data in the database or how many users are logged in.]]

---

**Self-Check 9.4: Comments and Commits: Documenting Code**

Information regarding how certain code works and information future developers may need to know while working on code should be included in:

(x) In the comments
( ) In commit messages
( ) In both comments and commit messages
( ) Neither. They belong in a writeup separate from the code

[[Commit messages should be treated as more for historical information, such as why a certain function was deleted or refactored. Comments should reflect how the code works as it exists in the present moment.]]

---

**Self-Check 9.5: Metrics, Code Smells, and SOFA**

Which is generally FALSE about code smells?

(x) More code is bad; less code is good
( ) They can occur both within a class and in interactions among classes
( ) They may indicate correctness problems
( ) They do not necessarily require repair

[[The correct answer is an absolute claim that's not true all the time. More code could be more clear, easier to read, with self-documenting variables. It could be the right length to do what it needs to do. Conciseness may lead to worse readability and less maintainability.]]

---

**Self-Check 9.6: Method-Level Refactoring: Replacing Dependencies with Seams**

Which is NOT a goal of method-level refactoring?

(x) Eliminate bugs
( ) Reduce code complexity
( ) Eliminate code smells
( ) Improve testability

[[While removing bugs is great, refactoring is supposed to change the code's structure WITHOUT changing its behavior. Don't conflate bug-fixing with refactoring.]]

---

**Self-Check 9.7: The Plan-And-Document Perspective on Working with Legacy Code**

Which statement regarding P-D maintenance is FALSE?

(x) All of these statements are true
( ) The cost of maintenance usually exceeds the cost of development in P-D
( ) The Agile equivalent to P-D change requests is user stories, equivalent of change request cost estimates is points, P-D releases are iterations
( ) The Agile lifecycle is similar to the P-D maintenance lifecycle: enhancing working software product, collaborating with customer vs. negotiating by contract, continuously responding to change

[[As described in the answer choices]]
