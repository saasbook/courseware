# Module 5 Self-Checks

**Self-Check 5.1: DRYing Out MVC: Partials, Validations and Filters**

Which Ruby language features support the DRYness enabled by validations and filters: (a) higher-order functions (b) closures (c) metaprogramming

(x) (a), (b) and (c)
( ) Only (a)
( ) Only (a) and (b)
( ) Only (a) and (c)

[[Metaprogramming comes into play in that we can provide the name of a validation method as a symbol or string and have Rails resolve and call the actual method at runtime. In validations where we provide an inline lambda-expression, as in validates_presence_of :rating, :if => { self.release_date.year > @ratings_history_date }, higher-order functions are used (we are essentially passing an anonymous function with :if) along with closures (the values of variables such as @ratings_history in the lambda-expression will be the values in scope in the place where the lambda-expression is first defined, even though that place is far away from where it will be called).]]

---

**Self-Check 5.2: Single Sign-On and Third-Party Authentication**

Which is true about third-party authentication between a requester and a provider?

( ) Once completed, the requester can do anything you can do on the provider
( ) If your credentials on the requester are compromised, your credentials on the provider are also compromised
( ) If the provider revokes access, the requester no longer has any of your info
(x) Access can be time-limited to expire on a pre-set date

[[Most third-party authentication schemes support expiration, to limit the damage in case the requester is compromised.]]

---

**Self-Check 5.4: Associations and Foreign Keys**

Which statement is false regarding Cartesian products as a way of representing relationships?

(x) You can only filter based on on primary or foreign key (id) columns
( ) You can represent one-to-one relationships as well as one-to-many relationships
( ) You can represent many-to-many relationships
( ) The size of the full Cartesian product is independent of the join criteria

[[You can filter on any columns you wish. However, because Rails and other frameworks use filtered Cartesian products specifically as a way to model relationships between model entities, Rails only uses the primary and foreign keys of model tables as filter criteria for joins.]]

---

**Self-Check 5.5: Through-Associations**

Which of these, if any, is NOT a correct way of saving a new association, given m is an existing movie:

(x) All will work
( ) Review.create!(:movie_id=>m.id, :potatoes=>5)
( ) r = m.reviews.build(:potatoes => 5)r.save!
( ) m.reviews << Review.new(:potatoes=>5)m.save!

[[The invariant is that the movie_id attribute must be filled in when the review is created. All the choices accomplish this. The first option does it by explicitly setting the attribute value on create. The second uses the build method, which is provided by the Associations module as a way to create a new instance of an owned object that has the owning object's primary key already filled in as the foreign key; Rails can deduce the foreign key column name (movie_id) and the ID of the owning object because the owning object is the receiver of build. Similarly, when associations are used, << is redefined to "fill in" the foreign key on the newly-created owned object before it is added to the "collection" owned by the owning object. As an aside, note that in the third case, saving an owning object has the side effect of saving its owned objects---even if the owning object itself isn't changed by adding more owned objects to it (as is the case here).]]

---

**Self-Check 5.6: RESTful Routes for Associations**

If we also have moviegoer has_many reviews, can we use moviegoer_review_path() as a helper?

(x) Yes, but we must declare reviews as a nested resource of moviegoers in routes.rb
( ) Yes, it should work as-is because of convention over configuration
( ) No, because there can be only one RESTful route to any particular resource
( ) No, because having more than one through-association involving Reviews would lead to ambiguity

[[This will work, but we need to be explicit about what we want in routes.rb. The reason is that the concept of the association is separate from the concept of how to construct routes for it: in some cases we might want a route that gets us to a review by "traversing" the movie that owns it, in other cases we might want to get to a review by "traversing" the moviegoer that wrote it, but in either case the underlying association is the same--what's different is how we choose to represent it in a route.]]

---

**Self-Check 5.8: Other Types of Code**

To encapsulate queries that touch many different models, what kind of object should be used?

(x) Query Object
( ) Policy Object
( ) Service Object
( ) Form Object

[[As in the name, query objects encapsulate queries that involve multiple models. Policy objects are special cases of service objects that focus on enforcing constraints on multiple models. Form objects process data submissions that require updates to multiple models, while service objects can be thought of as a super class to form, query, and policy objects. They encapsulate any operations that read and write to multiple models, such that it's unnatural to assign the logic as a special case of a single model.]]
