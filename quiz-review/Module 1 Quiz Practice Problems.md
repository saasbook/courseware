# **Module 1 Problems**

Answers are **bolded**. 

## Agile vs. Waterfall

Which statements are true regarding the Waterfall software design process?

Progress is measured primarily through validation rather than verification

Tests are written before the actual code

**It works well when customers don’t change their mind about what they want**

Multiple prototypes and iterations are used to improve the product over time

**The later that errors are found, the more costly they tend to be to fix**

## Agile & Spiral Similarities

What are some similarities between the Agile and Spiral methodologies?

**Use of requirements**

Test-driven development

**Prototypes that are evaluated by the customer**

**Improving the product over multiple iterations**

## Agile Values

Agile values:

**Responding to change**

Writing comprehensive documentation

**Collaborating with the customer**

Measuring project progress against an initial plan

**Individuals and interactions**

## Productivity Mechanisms, Part 1

In Ruby, you can write the line "attr_reader :name_of_instance_variable" inside a class. Then for any instance X of that class, you can call X.name_of_instance_variable to access the instance variable without having to define the getter method inside the class explicitly. What productivity mechanism(s) does this feature illustrate?

**clarity via conciseness**

**synthesis**

reuse

**automation**

none of the above

## Productivity Mechanisms, Part 2

While creating a new piece of software, you realize that instead of repeatedly copy-pasting code, it would be more efficient if you simply defined a few helper functions. Defining and using these helper functions allows you to understand your code better and significantly reduces the total number of lines of code. Also, you find it much easier to enhance your design and add new features by using the helper functions. Which productivity mechanism(s) does this illustrate?

**clarity via conciseness**

synthesis

**reuse**

automation

none of the above

## SaaS Priorities

You are creating a SaaS application and want to ensure that your service is consistently accessible at any time of the day, regardless of the amount of incoming network traffic. Which terms BEST describe your key priorities?

**scalability**

integrity

**availability**

security

communication

## Legacy Code Characteristics

What are some typical characteristics of legacy code?

**It meets customer requirements**

**Enhancing it constitutes the majority of software maintenance costs**

It has bugs

**The code is difficult to evolve**

## Software Development With APIs

The use of APIs in the development of software applications illustrates:

Metaprogramming

**Service oriented architecture**

OS-level virtualization

Functional programming

**The productivity mechanism of reuse**

Reflection

## Buggy Application

You have a bug in your application. Though it is not visible to the end-user, whenever you click the submit button on a form, it immediately purges the contents of your database. You didn’t find this bug because you didn’t write any tests (uh oh!) and the end-user is currently unable to view the database contents from the user interface. Which level(s) of testing could have helped you to isolate this issue?

**Unit Testing**

**Module Testing**

**Integration Testing**

Acceptance Testing

### Explanation

Unit testing for form submission logic, module/integration testing for the interaction between the form submission logic and the database operations. Acceptance testing would probably not help here because the end-user cannot see what is happening in the database.
