# **Module 5 Problems**

Correct answers are either **bolded** or indicated with #answer. 

## Cartesian Product

Suppose you have n tables labeled {1, 2, … n} and table j has r_j rows and c_j columns. What is the total number of rows and columns in the Cartesian product of all the tables?

Rows: r_1 + r_2 … + r_n,  Columns: c_1 * c_2 * … * c_n

Rows: r_1 * r_2 … * r_n,  Columns: c_1 * c_2 * … * c_n

**Rows: r_1 * r_2 … * r_n,  Columns: c_1 + c_2 + … + c_n**

Rows: r_1 + r_2 … + r_n,  Columns: c_1 + c_2 + … + c_n

## Associations Part 1

Suppose that the relationship between the schools and teachers database has been correctly set up so that a school has many teachers and a teacher belongs to a school in Rails. There is a foreign key **school_id** in the teachers table for this purpose and **berkeley** is an existing school in the schools database. Which of these options correctly <span style="text-decoration:underline;">saves an association to the database</span>, assuming that none of the lines of code below throw an error?

teaching_assistant = berkeley.teachers.build(name: “TA for CS169”)

**berkeley.teachers &lt;< Teacher.new(name: “TA for CS169”)**

**Teacher.create!(school_id:[ berkeley.id](http://berkeley.id), name: “TA for CS169”)**

<span style="text-decoration:underline;">Associations Part 2:</span>

Suppose that the relationship between the schools and teachers database has been correctly set up so that a school has many teachers and a teacher belongs to a school in Rails. There is a foreign key **school_id** in the teachers table for this purpose and **berkeley** is an existing school in the schools database. Which of the following code snippets would update BOTH the schools table AND the teachers table, assuming that none of the lines of code below errors?

```ruby
berkeley.teachers << Teacher.new(name: “TA for CS169”)
berkeley.save!
```

```ruby
stanfurd = School.create!(name: “Stanfurd”) #answer
stanfurd.teachers.create!(name: “TA for CS295”) #answer
```

Both of the above

Neither of the above

## Foreign Keys

Suppose we want to model a relationship between two entities A and B in our Rails application. Which of the statements are true?

Implementing the relationship A belongs to B requires a foreign key column in B referencing A

**Implementing the relationship B has many A requires a foreign key column in A referencing B**

Implementing both the relationships A has many B and B has many A requires foreign key columns both in A and B

**Implementing the relationship A has many B through C requires foreign keys in C that reference both A and B**

## Nested Resource Routes

Suppose we have the following code in the **routes.rb** file of a Rails application:

```ruby
Rails.application.routes.draw do 
	resources :authors do 
		resources :books 
	end 
end
```

Which of the following are valid routes corresponding to the specified HTTP methods and actions? Assume that the book with **book_id** = 2 and the author with **author_id** = 1 exist in the database.

**GET /authors/1/books**

**POST /authors**

GET edit_book_author_path(author_id: 1, id: 2)

GET book_path(id: 2)

**GET authors_path**

**GET author_books_path(author_id: 1)**

<span style="text-decoration:underline;">Other topics to review:</span> aspect-oriented programming (AOP)


# **Module 6 Problems:**

## Simplest Strategy Part 1

You want to implement a “Hide and Seek” button on your website. Clicking this button should immediately modify the current page so that every **button** nested inside a **div** element is immediately hidden. But whenever you click somewhere on the page, if you click on the div element surrounding an element, it reappears. What is the **simplest** strategy to implement this feature?

Can be implemented entirely in HTML and CSS (no JavaScript needed)

**Requires JavaScript, but can run entirely in the Web browser (no communication with the server is needed after the initial page load)**

Requires JavaScript AND communication with the server after the initial page load completes, ie AJAX

Requires a full page reload (can't be done by updating the page in place using AJAX)

## Simplest Strategy Part 2

You want to implement a “Search” feature on your bookstore’s website. When you begin typing into the search bar, you should see suggestions for books to buy with titles that match what you started typing that change as you continue typing your query (this is similar to Google’s search feature). What is the **simplest** strategy to implement this feature?

Can be implemented entirely in HTML and CSS (no JavaScript needed)

Requires JavaScript, but can run entirely in the Web browser (no communication with the server is needed after the initial page load)

**Requires JavaScript AND communication with the server after the initial page load completes, ie AJAX**

Requires a full page reload (can't be done by updating the page in place using AJAX)

## Javascript

Select the statements that are true about Javascript:

Multiple functions can be run in parallel

**Javascript modifies HTML pages by querying the DOM API**

**It supports higher-order functions and anonymous functions**

**JS can be used to implement client-side validations in your application**

**If your browser does not support Javascript, and you visit an application that uses Javascript, the application will behave as if the Javascript isn’t executed at all**

### Other Topics to Review for Final (but not in-scope for tomorrow’s quiz)

Testing AJAX using Jasmine/RSpec


# **Module 7 Problems:**

## Imperative vs. Declarative

Which statements are true about imperative versus declarative scenarios?

Imperative scenarios generally take more lines of code to write than declarative scenarios

Whereas imperative scenarios usually address implicit requirements, declarative scenarios tend to address explicit requirements

Declarative scenarios usually address functional requirements while imperative scenarios address nonfunctional requirements

Imperative scenarios tend to be simpler and less verbose than declarative scenarios

**Imperative scenarios are preferred for expressing the details of the user interface as they relate directly to business value or customer need**

## Agile Teams

Which are characteristic of Agile teams?

The product owner is primarily responsible for delivering finished stories to the customer

**Progress is measured using points and velocity**

Each member of the team should claim and prioritize their own stories

**Stories with higher value to the customer should generally receive higher priority**

**After a user story is delivered, the customer (or product owner) decides whether that story is accepted/rejected**

## SMART Stories

Which of the following user stories can be considered SMART? Recall the criteria for a SMART user story:
- S: Specific
- M: Measurable
- A: Achievable
- R: Relevant
- T: Time-bound
  
As a user, I want better search functionality on this website.

**As a frequent shopper, I want a search filter on the products pages so that I can refine results by price range and product category, so that I can easily find and purchase products that match my needs.**

As a recruiter, I can post new job openings.

As a user, I can post a photo.

**As a lover of theme parks, I want to be able to purchase tickets & concessions online, so that I don’t have to wait in line when I get there.**