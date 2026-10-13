# Module 8 Self-Checks

**Self-Check 8.1: FIRST, TDD, and Red–Green–Refactor**

Which kinds of code can be tested Repeatably and Independently?

(i) Code that relies on randomness (e.g. shuffling a deck of cards);

(ii) Code that relies on time of day (e.g. run backups every Sunday at midnight).

(x) Both
( ) Only (i)
( ) Only (ii)
( ) Neither

[[With randomness, we can test repeatably by using a random number seed that fixes the order of random numbers from a generator. For the time of day, we can use an approach called “stubbing” that can help us define a mock context that allows code to run.]]

---

**Self-Check 8.2: Anatomy of a Test Case: Arrange, Act, Assert**

Which of these, if any, is NOT a valid expectation?

(x) expect(5).to be <=> result
( ) expect(result).not_to be_empty
( ) expect(result).to match /^D’oh!$/
( ) All of these are valid expectations

[[An explanation is like an assertion, in that it checks whether something is strictly true or false. “expect(5).to be <=> result” is a comparison expression that evaluates to -1, 0, or 1, instead of true or false.]]

---

**Self-Check 8.3: Isolating Code: Doubles and Seams**

Which is FALSE about expect(...).to receive?

(x) It can be issued either before or after the code that should make the call
( ) It provides a stand-in for a real method that doesn’t exist yet
( ) It would override the real method, even if it did exist
( ) It exploits Ruby’s open classes and metaprogramming to "intercept" a method call at testing time

[[The expect(...).to receive matcher clause must be issued after the code making the call, as it serves as an assertion that certain effects were caused by the method calls.]]

---

**Self-Check 8.4: Stubbing the Internet**

to_receive combines _____ and _____, whereas stub is only _____.

(x) A seam and an expectation, a seam
( ) A mock and an expectation, a mock
( ) A mock and an expectation, an expectation
( ) A seam and an expectation, an expectation

[[Recall that seams help you isolate the behavior of an application and change it without having to change the code, while an expectation is similar to the idea of an assertion that indicates what about the nature of an application should be true.]]

---

**Self-Check 8.6: Fixtures and Factories**

Which of the following kinds of data, if any, should not be set up as fixtures?

(x) Movies and their ratings
( ) The TMDb API key
( ) The application's time zone
( ) Fixtures would be fine for all of these

[[Recall that the definition of a fixture is a fixed state that is used as a baseline for running tests in software testing. Therefore, it’d be best to set up any data that is not dependent on the user’s configurations as fixtures. In this case, movies and their ratings can be divulged to other developers, but users may have their own unique API key and live in different time zones.]]

---

**Self-Check 8.7: Coverage Concepts and Types of Tests**

Which of these is POOR advice for TDD?

(x) Unit tests give you higher confidence of system correctness than integration tests
( ) Mock and stub early and often in unit tests
( ) Aim for high unit test coverage
( ) Sometimes it’s OK to use stubs and mocks in integration tests

[[More unit tests and more test coverage in general is correct, but it doesn’t necessarily translate to more system correctness. Recall that unit tests target functionality at very technical levels (does this method work as intended). Integration tests are much more comprehensive and test several software modules altogether as a group. Therefore, it reflects system correctness more accurately.]]

---

**Self-Check 8.8: Other Testing Approaches and Terminology**

Which non-obvious statement about testing is FALSE?

(x) Testing eliminates the need to use a debugger
( ) Even 100% test coverage is not a guarantee of being bug-free
( ) If you can stimulate a bug-causing condition in a debugger, you can capture it in a test
( ) When you change your code, you need to change your tests as well

[[Recall that even 100% test coverage doesn’t mean code is bug free, whether it is with regards to the technical implementation or overall system correctness according to the customer behavior. Therefore, using a debugger is still needed to trace errant behavior that may not be covered by an existing test, or perhaps cannot be written as a test (non-deterministic errors).]]

---

**Self-Check 8.10: The Plan-And-Document Perspective on Testing**

Which statement regarding testing is FALSE?

(x) Formal methods are expensive but worthwhile to verify important applications
( ) PandD developers code before they write tests while its vice versa after
( ) Agile developers Agile developers perform module, integration, system, and acceptance tests. PandD developers don’t
( ) PandD sandwich integration aims to reduce wasted work making stubs while trying to get general functionality early

[[Recall that formal methods use mathematical proofs to verify whether applications are performing correctly. These methods are indeed expensive, and while helpful, they are not worthwhile for verifying application correctness because of 1. How time and labor intensive developing formal methods are and 2. They must be updated as the application changes, which is not feasible in an Agile environment.]]
