# Module 4 Self-Checks

**Self-Check 4.1: The Model–View–Controller (MVC) Architecture**

Which statement is NOT true about the Model--View--Controller (MVC) architectural pattern?

(x) All MVC apps have both a "client" part (e.g. Web browser) and a "cloud" part (e.g. Rails app on cloud).
( ) In SaaS apps on the Web, controller actions and view contents are transmitted using HTTP.
( ) Model-View-Controller is just one of several possible ways to structure a SaaS app.
( ) Peer-to-peer apps (vs. client-server apps) can be structured as Model-View-Controller.

[[The Model View Controller design pattern is more concerned with how to divide program logic into three categories, and is less concerned with where the code is actually placed (i.e. the client and cloud)]]

---

**Self-Check 4.2: Rails Models: Databases and Active Record**

Which statement is NOT true about the Model in Model--View--Controller:

(x) The CRUD actions only apply to models backed by a database that supports ActiveRecord.
( ) Part of the Model's job is to convert between in-memory and stored representations of objects.
( ) Although model data is displayed by the View, a Model's direct interaction is with Controllers.
( ) Although DataMapper doesn't use relational databases, it's a valid way to implement a Model.

[[Recall that the MVC design pattern focuses on dividing program logic, and is not as concerned with the technical disparities within the implementations themselves, such as differences among languages and platforms. Therefore, the database doesn’t necessarily need to support ActiveRecord.]]

---

**Self-Check 4.4: Routes, Controllers, and Views**

Which statement is NOT true regarding Rails RESTful routes and the resources to which they refer?

(x) The route always contains one or more 'wildcard' parameters such as :id to identify the particular resource instance used in the operation.
( ) A resource may be existing content or a request to modify something.
( ) In an MVC app, every route must eventually trigger a controller action.
( ) One common set of RESTful actions is the CRUD actions on models.

[[A route does not necessarily need to have a parameter in general. For instance, for a Movies application, a “GET /movies” route could be a valid request, with no parameters, that retrieves an exhaustive list of all movies.]]

---

**Self-Check 4.5: Forms**

Which of these would be valid Haml for generating the form that, when submitted, would call the Create New Movie action?

(x) All of these answers are valid
( ) = form_tag movies_path do ... end
( ) %form{:action => movies_path, :method => :post}
( ) %form{:action => 'movies', :method => 'post'}

[[All that is required by the browser is a tag with an action attribute whose value is the submission URI and whose method attribute names the HTTP method (GET or POST) for submitting the form. All three versions of the code above would generate a tag with these attributes and values.]]

---

**Self-Check 4.7: Debugging: When Things Go Wrong**

If you use puts or printf to print debugging messages in a production app:

(x) Your app will continue, but the messages will be lost forever
( ) Your app will raise an exception and grind to a halt
( ) Your app will continue, and the messages will go into the log file
( ) The SaaS gods will strike you down in a fit of rage

[[The built in “puts”, similar to “print” in Python and “println” in Java, shows messages in the standard output. However, when an app is running in production, there is no viewable standard output, so “puts” outputs will not be recorded.]]
