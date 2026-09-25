# Module 3 Self-Checks

**Self-Check 3.1: The Web's Client–Server Architecture**

Choose the terms that make a true statement: A ____ can create and modify cookies; the ____ is responsible for including the correct cookie with each request.

(x) SaaS app; browser
( ) Browser; SaaS app
( ) HTTP request; browser
( ) SaaS app; HTTP response

[[The SaaS app has the responsibility of creating cookies that correspond to running user sessions which hold on to persisted information. The browser checks cookies to verify whether certain requests and operations are allowed.]]

---

**Self-Check 3.2: SaaS Communication Uses HTTP Routes**

Which statement is true about the two HTTP requests: GET /foo/bar POST /foo/bar

(x) They are distinguishable and may have different behaviors
( ) They are indistinguishable to a SaaS app
( ) They are distinguishable and must have different behaviors
( ) A given app can handle one or the other, but not both

[[The are distinguishable because of the different HTTP request types (GET vs. POST), and they don’t have to have different behaviors, because a method can be defined to accept and handle routes that might have different request types.]]

---

**Self-Check 3.4: From Web Sites to Microservices: Service-Oriented Architecture**

Match the terms: (a) presentation tier, (b) logic tier, (c) persistence tier

(x) (a) Apache web server (b) Rack+Rails (c) database
( ) (a) Firefox (b) Apache web server (c) PostgreSQL
( ) (a) Microsoft Internet Information Server (b) Rack+Rails (c) Apache web server
( ) (a) Firefox (b) Microsoft Internet Information Server (c) MySQL

[[Recall that the presentation tier refers to the front end layer that presents the user interface, the logic tier contains the core capabilities, and the data tier is for storage.]]

---

**Self-Check 3.5: RESTful APIs: Everything is a Resource**

In the (fictitious) API documentation for `GET /books/:book_id?format=long` which arguments are required?

(x) book_id is required, but can’t tell if format is required without looking at API docs
( ) book_id and format are both required
( ) book_id is required, format is optional
( ) Both are optional
( ) Can’t say anything about either one without looking at the API docs

[[We can tell book_id is necessary because the route would be incomplete without it. However, there’s no way to tell whether format is needed based on the route format alone.]]

---

**Self-Check 3.6: RESTful URIs, API Calls, and JSON**

Below are possible routes for manipulating Movie resources:

- Read: GET /movies/253

- Update: PUT  /movies/253?rating=PG

- Create: POST /movies

The "Read" and "Update" routes have an ID.  Why doesn't the "Create" route have an ID?

(x) The movie hasn’t been created yet, so it doesn’t have an ID
( ) It will be carried in POST request body, along with data about the new movie
( ) The route is incomplete: it should be something like “POST /movies/:movie_id”

[[When resources are stored in a relational database, they generally do not get an ID until they are created.]]
