# **Module 4 Problems:**

Correct answers are **bolded**.

<span style="text-decoration:underline;">Information control:</span>

Match the following elements:

| Term                               | Description                                             |
|------------                        |------------------------------------                     |
| params[]                           | passes information from the view to the controller      |
| controller instance variables      | passes information from the controller to the view      |
| flash[]                            | persists information to the next request                |
| session[]                          | can persist information across any number of requests   |


<span style="text-decoration:underline;">MVC:</span>

Select all statements that are true about an MVC app:

**Incoming requests are handled by the controller**

**While the view is closest to the client, the model is closest to the database**

It is illegal for the view to directly access the model’s data

**Every valid route eventually triggers either a render or a redirect**

<span style="text-decoration:underline;">Chicken Part 1:</span>

Suppose you write the following line in your routes.rb file in Rails:

```ruby
resources "chicken"
```

This automatically generates RESTful routes for a “chicken” resource in your app. What is true about the routes that are generated?



* A form to create a new chicken should make a GET request to the path “/chickens” to call the chickens#create controller action
* **The path “edit_chicken_path” requires an argument to specify which chicken needs to be edited**
* **The path “chicken_path” requires either the ID of a chicken or an instance of the Chicken class as an argument**
* A request made to “chickens_path” results in either a chicken being deleted or updated, depending on what HTTP method is used

 

<span style="text-decoration:underline;">Chicken Part 2:</span>

Suppose that the chickens database is initially empty, and we have the Chicken ActiveRecord model defined as below:

```ruby
class Chicken < ActiveRecord::Base
  #assume the only database columns are ‘id’ and ‘name’
  attr_accessor :age
  def initialize(attributes = {})
    @age = 0
    super(attributes)
  end
end

bob = Chicken.create(name: 'Bob')
db_bob = Chicken.find_by(name: 'Bob')
db_bob.age = 4
```

What are the values of bob.age, db_bob.age, and Chicken.find_by(name: "Bob").age, respectively?

0, 0, 0

0, 0, 4

0, 4, 4

4, 0, 4

4, 4, 4

**0, 4, 0**

4, 4, 0

None of the above

<span style="text-decoration:underline;">Warnings:</span>

In your application, you want to make sure that if your user presses a certain button on page X, then upon being redirected to page Y they see a “Warning: this page contains sensitive information” message. What is (arguably) the easiest and most appropriate way to do this in Rails?

Save the warning message in a controller instance variable

**Put the warning message in the flash[]**

Store the warning in the session[]

Pass the warning in the params[]

<span style="text-decoration:underline;">Migrations:</span>

Select the statements which are true regarding migrations in Rails:

**Migrations serve as version control for changes to the database**

Because of Rails’ convention over configuration, running the lines 
```ruby
rails generate migration CreateChickenNuggets name:string
```
and 
```ruby
rails db:migrate 
```
will automatically create a "ChickenNugget" database with a "name" column

Any changes to a database schema like deleting/adding columns <span style="text-decoration:underline;">must</span> be done through a migration script

In the migration script for creating a new table, the change method returns an object representing an instance of the corresponding model