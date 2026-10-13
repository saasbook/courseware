# Module 11 Self-Checks

**Self-Check 11.1: Patterns, Antipatterns, and SOLID Class Architecture**

Which of the following statements is FALSE?

(x) Most design patterns are specific to a particular subset of programming languages.
( ) Software that uses more design patterns isn’t necessarily better.
( ) Well-designed software can evolve to the point where patterns become antipatterns.
( ) Trying to apply design patterns too early can be just as bad as applying them too late.

[[While a few design patterns arise from language-specific constraints, the great majority of them can be applied no matter what language you use, because design patterns are about relationships among different classes or entities in your code.]]

---

**Self-Check 11.2: Just Enough UML**

![The image is a UML class diagram. The name and fields of each entity will be described first, followed by the ActiveRecord associations.  Entities: Account Code: No fields Item: Price, sold_on, transfer_to_customer, refund Customer: name, email, subscriber?, merge_with, expunge! Donation: fund_code Voucher: reserved?, changeable?, reserve!, redeemable_for_show? Vouchertype: name, season, merge_with, expunge! Showtime: date_and_time, start_sales, end_sales, house_capacity, revenue_per_seat Show: name, list_starting, revenue_per_seat  Associations: AccountCode => VoucherType (1 to Many) AccountCode => Item (1 to Many) Item => Customer (1 to Many) Voucher => VoucherType (Many to 1) Voucher => ShowDate (Many to 1) Voucher => Item (1 to 1) Donation => Item (1 to 1) Show => ShowDate (1 to 1)](https://courses.edx.org/assets/courseware/v1/4f6b1a91a60a9816b6c842aca955bb8b/c4x/BerkeleyX/CS.169.2x/asset/diagram.png)

Which ActiveRecord association would NOT appear in a Rails app that follows this simplified UML class diagram?

(x) Item has one AccountCode
( ) Show has many Vouchers, through Showdate
( ) Customer has many Donations
( ) Voucher belongs to Vouchertype

[[It is true that a given Item has only a single AccountCode, but has-one is a 1-to-1 relationship, and the diagram shows that an AccountCode has many Items. So the relationship expressed here is Item belongs to AccountCode and AccountCode has many Items.]]

---

**Self-Check 11.3: Single Responsibility Principle**

Which is true about a class's observance of the Single Responsibility Principle?

(x) Low cohesion is a possible indicator of an opportunity to extract a class
( ) In general, we would expect to see a correlation between poor cohesion score and poor SOFA metrics
( ) If a class respects SRP, its methods probably respect SOFA
( ) If a class's methods respect SOFA, the class probably respects SRP

[[While good style and freedom from smells are important at both the method and class level, they are largely orthogonal. A class with too many responsibilities could have lots of small methods that all follow SOFA, and a class with one responsibility might implement that responsibility with methods that run afoul of SOFA.]]

---

**Self-Check 11.4: Open/Closed Principle**

OmniAuth defines a handful of RESTful endpoints your app must provide to handle authentication with a variety of third parties. To add a new auth provider, you create a gem that works with that provider. Which statement is FALSE about OmniAuth?

(x) OmniAuth is an example of the Template pattern
( ) OmniAuth is itself compliant with OCP
( ) Using OmniAuth helps your app follow OCP (with respect to 3rd-party authentication)
( ) OmniAuth is an example of the Strategy pattern

[[From your app's point of view, the API to authentication is just a few URL endpoints, but the process by which it's done varies wildly depending on the auth provider. Some are OAuth, some implement proprietary protocols, some aren't authentication protocols at all but just testing stubs. So OmniAuth is more like Strategy, since it doesn't consist of overriding a fixed sequence of steps that are basically the same for all authentication providers.]]

---

**Self-Check 11.5: Liskov Substitution Principle**

(a) In duck-typed languages, LSP violations can occur even when inheritance is not used (b) In statically-typed languages, if the compiler reports no type errors/warnings, then there are no LSP violations

(x) Only (a) is true
( ) Only (b) is true
( ) Both are true
( ) Both are false

[[(a) is true: For example, in Ruby, you might mix in the Comparable module but define <=> in a way that doesn't obey the triangle inequality. Even though there is no inheritance here, you've violated the contract expected by the mixed-in module.]]
[[(b) is false: The Square/Rectangle example explained in the lecture (and at http://pastebin.com/nf2D9RYj) would pass static type checks, yet it violates LSP.]]

---

**Self-Check 11.6: Injection of Dependencies Principle**

In RSpec controller tests, it's common to stub ActiveRecord::Base.where, an inherited method. Which statements are true of such tests:

a. The controller under test is tightly coupled to the model

b. In a static language, we'd have to use DI to achieve the same task in the testing framework.

(x) both (a) and (b)
( ) only (a)
( ) only (b)
( ) neither (a) and (b)

[[a. The controller is calling where directly, suggesting that it has detailed knowledge of the database schema for the model.]]
[[b. Injecting a dependency would allow whichever method is called to be replaced at testing time with a double.]]

---

**Self-Check 11.7: Demeter Principle**

Suppose Order belongs to Customer, and a view has @order.customer.name. Is this a Demeter violation?

(x) Yes...you can make a case for either of the above
( ) Yes...but probably reasonable to just expose object graph in the view in this case
( ) Yes...replace with Order#customer_name which delegates to Customer#name
( ) No...by using belongs_to we're already exposing info about the Customer anyway

[[A view is about showing information about the models, so it's not unusual for a view to be somewhat coupled to its models and be able to display a representation of the 'object graph'. On the other hand, purists could indeed create a delegate to handle this, and we could hardly disagree with that. So technically it is a Demeter violation, but reasonable people could make a case for either a non-fix or a delegate fix.]]

---

**Self-Check 11.8: The Plan-and-Document Perspective on Design Patterns**

Which statement regarding design patterns is FALSE?

(x) None are false; all are true
( ) P&D processes have an explicit design phase that is a natural fit to the use of design patterns and thus will have a good SW architecture
( ) P&D drawback: initial architecture & design patterns may change as code written and system evolves
( ) Agile developers may plan for SW architectures and design patterns they expect to need based on previous, similar projects

[[As described in the answer choices]]
