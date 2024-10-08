# **Module 10 Problems:**

Correct answers are **bolded**.

## Git Commands Part 1

You and your friend decide to collaborate on a new feature for your app. First, you make a branch for a new feature. Then, you switch to the new branch, modify a bunch of files, and save your changes to the remote shared repository. Which Git commands **could** you reasonably have used to **directly** perform one or more of these operations?

**git stage**

**git branch**

git new 

git explode

**git commit**

git move

**git switch**

**git checkout**

**git add**

**git push**

## Git Commands Part 2

Your friend pulls your changes and realizes that your changes somehow broke the application. Using git commands, he identifies the specific lines that you added and removed from each file. After detailed investigation, your friend decides to undo the work of some of your previous commits so that he can effectively start working from one of your older commits on the feature branch (before stuff broke). Which Git commands **could** your friend have reasonably used to **directly** perform one or more of these operations?

git cherry-pick

**git rebase**

**git checkout**

**git log**

git undo

**git blame**

git redo

git history

git override

git rm

**git diff**

**git revert**

git delete

## A Bug’s Life

Which of the following options are NOT typically steps in the lifecycle of a bug?

**Deciding who is going to work on the bug**

Fixing the bug

Verifying that the bug actually needs to be fixed

Creating a regression test to demonstrate the bug

**Estimating the monetary cost of fixing the bug**

Reporting the bug


# **Module 11 Problems:**

## Matching Designs

Match each situation to the design pattern that is being illustrated:

- **Composite**:
  - The `Library` class implements an `add` function which allows you to add either individual books or collections of books to the catalog.

- **Null Object**:
  - A teacher’s record is automatically linked to the “Unknown School” object in the schools database if they fail to specify the name of their school when signing up on a website.

- **Factory**:
  - The command `talk_to` can be called on any type of chicken. It will create a new chicken of the specified type at runtime and return the result of calling the `respond` method on the chicken instance. A friendly chicken will respond “cluck,” an angry one will respond “SQUAWK!,” and a special chicken will respond “moo.”

- **Strategy**:
  - Google Maps optimizes navigating to a given location depending on whether you prefer to bike, walk, or drive.

- **Proxy**:
  - For efficiency reasons, the object returned by the `where` method in ActiveRecord doesn’t actually perform the query until you ask it for one of its elements.

## Are you SOLID?

Match each SOLID principle with a symptom suggesting that it has been violated:

- **Single Responsibility Principle**:
  - A specific group of variables is frequently passed together or returned as the set of results from methods within your program.

- **Liskov Substitution Principle**:
  - The class `Circle`, which inherits from `Ellipse`, destructively overrides the `set_major_axis_length` and `set_minor_axis_length` methods to set both the major and minor axes' lengths to a specified input value.

- **Demeter Principle**:
  - To get the zip code where someone lives, you frequently use the syntax `person.house.address.zip_code` throughout your code.

- **Open/Closed Principle**:
  - A method in your code has a significant amount of casework that checks the type of an object being passed into the method and takes a different action depending on the object type.

- **Dependency Injection Principle**:
  - A constructor of one of your potentially extensible classes makes a hardcoded call to another class’s constructor rather than determining which other class to use at runtime.

## Injecting Dependencies

When dependencies are injected between collaborating classes whose implementation may change at runtime, sometimes it is necessary to adapt and simplify the APIs of the classes involved. Which design patterns would <span style="text-decoration:underline;">most directly</span> help with accomplishing this?

Flyweight

**Facade**

Iterator

**Adapter**

Composite 

Template Method

Decorator