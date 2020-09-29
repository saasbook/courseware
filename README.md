Courseware for Engineering Software as a Service
================================================

a/k/a UC Berkeley CS (W)169(A,L) Software Engineering, a/k/a CS 169.(1,2,3)x on
EdX

## Review/Discussion materials (available to anyone)

This repo contains information useful to instructors (and arguably
students) using the [ESaaS](http://www.saasbook.info) course materials, including the following:
* `discussions`: Worksheets providing hands-on coding and problem solving exercises.
* `practice-exams`: Review slides and practice exams for midterms and finals.
* `self-checks`: Questions per module for students to verify their understanding.

The recommended setup is to [use Codio](https://codio.saasbook.info) for programming assignments and autograding; the [book's website](http://www.saasbook.info/instructors) has other options.  We no longer support Cloud9 or prebuilt VM images.

The Wiki also contains information on each of the autogradable homeworks,
which are public repos named `saasbook/hw-*`.  (The corresponding
private `saasbook/hw-*-ci` repos contain the autograder files and
reference solutions for each homework.)  The `-ci` repos are generally
off limits except to .

## Open ended questions for written exams ([instructor access only](https://www.saasbook.info/instructors))

[Open-ended response questions](/saasbook/open-response-exam-questions) suitable for manual grading, along with reference solutions.

## Multiple-choice/machine-gradable questions ([instructor access only](https://www.saasbook.info/instructors))

[Multiple choice questions](/saasbook/csw169a-quizzes) grouped by textbook chapter.  The [RuQL gem](/saasbook/ruql) and its associated formatters let you export quiz questions to HTML/hardcopy, the Canvas LMS, and other quiz formats.

## Coding Exam questions with autograders ([instructor access only](https://www.saasbook.info/instructors))

We've given exams where part of the exam is spent writing actual code. We have developed an infrastructure for doing this that allows students full read-only access to the Internet via Google's cache, so they can look up any existing information they want but cannot post a question or send email/messages to ask for the answers.  However, you can also use these as homework assignments since they included test cases.

The repos contain solutions and test cases as well as questions; instructions are provided in each repo's `README-instructor.md` for creating just the student-facing part of the package.

In our setup, since the questions are multiple parts with later parts building on the results of earlier ones, each question subpart is associated with a hint and/or with the answer (i.e. code that if copy-pasted in the right place will solve that subpart).  Students can "reveal" these hints if they accept a penalty of a substantial fraction of the points the exam question is worth.  The hints are part of each repo; our [reveal](/saasbook/reveal) script is installed in the exam environment (described in [this paper]((https://dl.acm.org/authorize?N680620)) to record which hints were used and calculate the penalty.  We [found](https://dl.acm.org/authorize?N680629) that weaker students do not request more hints than stronger students, even though they would sometimes benefit more from doing so; weaker students are more likely to request hints on lower-scoring coding questions than higher-scoring ones; and all students are equally well able to use hints once provided.

* [Interview Scheduler](/saasbook/exam-interviewscheduler-associations): Modify an existing app to add the correct associations among Interviews, Candidates, and Recruiters.  Factor out some common code among the models and mix it back in, to DRY out the code. [Solutions](/saasbook/exam-interviewscheduler-associations-
* **Incomplete** [Ruby Iterators](/saasbook/exam-ruby-iterators) Create Ruby iterators for a new `Matrix` class.
* [Can I Stream It?](/saasbook/exam-rottenpotatoes-canistreamit) Enhance RottenPotatoes by adding a view that displays information retrieved from the `CanIStream.it` API.
*  [Encryption Demo](/saasbook/exam-encrypty) Create this [simple app](https://encrypty.herokuapp.com) that allows users to specify a key for symmetric encryption and to encrypt/decrypt text with that key.
