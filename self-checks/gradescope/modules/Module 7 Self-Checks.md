# Module 7 Self-Checks

**Self-Check 7.1: Behavior-Driven Design and User Stories**

User Story 1: See which of my friends are going to a show - As a theatergoer - So that I can enjoy the show with my friends - I want to see which of my Facebook friends are attending a given show.

User Story 2: Show patron’s Facebook friends - As a box office manager - So that I can induce a patron to buy a ticket - I want to show her which of her Facebook friends are going to a given show.

(x) This should be left as 2 stories because the functionality and user experience may be different, & both may be important.
( ) This should be consolidated into a single user story from the patron’s point of view
( ) This should be consolidated into a single user story from the manager’s point of view

[[The goal of user stories is for customers and developers to agree on what is important. If there are stories that might seem similar, but address value from two different points of view, it is better to leave the stories separate to reflect what the customer wants for their business. Ultimately, it’s not up to developers to merge these stories without discussing with the customer.]]

---

**Self-Check 7.2: SMART User Stories**

Which Rottenpotatoes feature below is least smart?

(x) Given I have a free movie pass, I want to redeem it for an eligible movie before it expires
( ) As a user, I want to search for a movie by title
( ) When adding a movie, 99% of Add Movie pages should appear within 3 seconds
( ) As a customer, I want to see the top 10 movies sold, listed by price, so that I can buy the cheapest one first.

[[Any of the answers are potentially defensible as not living up to the SMART requirements. The reason the given answer was selected is because it doesn’t clarify what “eligible” actually means, and is not specific in general. However, all these stories have room for improvement. We leave it up to you to think about what those improvements might be?]]

---

**Self-Check 7.3: Lo-Fi User Interface Sketches and Storyboards**

Which of the following, if any, are usually NOT part of designing and implementing a typical user story?

(x) All of these answers are usually involved in designing and implementing a user story
( ) Front end code (HTML, views, JavaScript)
( ) Back end code (Rails)
( ) Tests (integration, acceptance, unit)

[[A story should not be marked as finished unless there are tests. Front end code and back end code are crucial to delivering the presentation and functionality of a user story, so all three are necessary to implementing a user story.]]

---

**Self-Check 7.4: Points and Velocity**

For the last 3 iterations, Team Blue’s average velocity is 8, Team Gold’s is 4. Which, if any, comparison between the Blue and Gold teams is valid?

(x) None of these answers are valid
( ) Blue has more developers than Gold
( ) Blue is twice as productive as Gold
( ) Blue has completed more stories than Gold

[[Recall that average velocity is a concept that is contained within the team. Comparing velocities between one team and another doesn’t make sense. A Velocity of a 4 for one team provides no detail about what a velocity of 4 for another team would be.]]

---

**Self-Check 7.5: Agile Cost Estimation**

Which expression statement regarding cost estimation is true?

(x) The cost bid is for PL time and materials that covers number of weeks in the estimate
( ) As practitioners of Agile Development, PL does not use contracts
( ) As practitioners of pair programming, PL estimates cost for 1 pair, which it assigns to complete project
( ) As studies show 84%-90% of projects are on-time and on-budget, plan and document managers promise customers a set of features for an agreed upon cost by an agreed upon date.

[[As described in answer choices. Incorrect answers are all false.]]

---

**Self-Check 7.6: Cucumber: From User Stories to Acceptance Tests**

Which is FALSE about Cucumber and Capybara?

(x) Step definitions are in Ruby, and are similar to method calls, while steps are in English and are similar to method definitions
( ) A Feature has one or more Scenarios, which are composed typically of 3 to 8 Steps
( ) Steps use Given for current state, When for actions, and Then for consequences of actions
( ) Cucumber matches step definitions to scenario steps using regexes, and Capybara pretends to be user that interacts with SaaS app accordingly

[[The statement is almost correct, except step definitions are more similar to method definitions (not calls), while steps are more similar to method calls (not definitions)]]

---

**Self-Check 7.8: Explicit vs. Implicit and Imperative vs. Declarative Scenarios**

Which is TRUE about implicit vs. explicit and declarative vs. imperative scenarios?

( ) Explicit requirements are usually defined with imperative scenarios and implicit requirements are usually defined with declarative scenarios
( ) Explicit scenarios are usually captured by integration tests
(x) All are false

[[Explicit scenarios usually capture acceptance tests that reflect user stories discussed with the customer. Declarative scenarios are more focused on behavior, not implementation. The remaining answer choice flips the definitions of explicit and implicit requirements (explicit requirements are defined with declarative scenarios, implicit with imperative scenarios.]]

---

**Self-Check 7.9: The Plan-And-Document Perspective on Documentation**

Which expression statement regarding P&D requirements and cost estimation is false?

(x) Agile has no equivalent to ensuring requirements, such as traceability
( ) The closest to the P&D schedule and monitoring tasks are agile points and velocity
( ) The closest to the P&D software requirements specification (SRS) document is Agile User Stories
( ) Actually, these statements are all true; none are false

[[Agile enforces and establishes requirements through customer meetings.]]
