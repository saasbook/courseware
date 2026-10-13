# Module 12 Self-Checks

**Self-Check 12.1: From Development to Deployment**

Let R = RottenPotatoes app's availability; H = Heroku's availability; C = Internet connection availability; P = Armando's perception of RP availability; Which relationship among these quantities holds?

(x) Can’t tell without additional information
( ) P <= C <= H <= R
( ) P >= min (C, H, R)
( ) P <= C <= min(H, R)

[[If Prof. Fox was accessing the site constantly around-the-clock, you could argue that his perception of availability would be no better than the minimum of C,H,R. But since we don't know how often or when he is accessing it, there's no way to tell. If the site is only down 1 minute per day but that's the only time he tries to access it, his perception will be 0% availability, and so on. This is one reason availability is more subtle to quantify than you might expect. SubmitSome problems have options such as save, reset, hints, or show answer. These options follow the Submit button.]]

---

**Self-Check 12.2: Three-Tier Architecture**

The master-slave configuration is appropriate for applications that experience what kind of workload?

(x) Read heavy
( ) Write heavy
( ) Equal distribution of read and write operations
( ) None, the configuration doesn't affect how the workload is handled

[[The master/slave configuration is a communication model where the master has control over multiple slave devices and load balances requests across the slave devices.]]

---

**Self-Check 12.3: Responsiveness, Service Level Objectives, and Apdex**

RottenPotatoes’ target uptime is 99.9%. Yesterday there was a one hour outage. Which statement is true:

(x) There isn’t enough information to determine whether RottenPotatoes can meet its user-perceived uptime goal
( ) Because of the outage, RottenPotatoes has no hope of meeting its uptime goal this year
( ) RottenPotatoes can still meet its uptime goal if there are no further outages this year
( ) If no live users actually tried to get to the site during the outage, uptime wasn’t hurt

[[Recall that Uptime is a measure of system reliability, expressed as the percentage of time a machine, typically a computer, has been working and available. Without knowing the time frame of the target uptime, there's no way for us to evaluate whether the percentage has been met.]]

---

**Self-Check 12.4: Releases and Feature Flags**

Which one, if any, is a POOR place to store the value (eg true/false) of a feature flag?

(x) A YAML file in config/ directory of app
( ) A column in an existing database table
( ) A separate database table
( ) These are all good places to store feature-flag values

[[If stored in a file, we need logic to determine if the file has changed and when it can be re-read, so that the feature flag value can be changed without restarting the app and re-reading all the config files. In contrast, database-stored values can be changed at runtime and the new values will be picked up immediately by the app.]]

---

**Self-Check 12.5: Monitoring and Finding Bottlenecks**

Which is probably NOT a metric of high interest to you, the app operator?

(x) Maximum CPU utilization
( ) Slowest queries
( ) 99 percentile response time
( ) Rendering time of 3 slowest views

[[As an operator, you should focus on metrics that directly impact the customer. While CPU utilization may be related to the other metrics, unless you know for certain that it's the root cause of poor behavior in those other metrics, you should instead focus on understanding why the other metrics are poor.]]

---

**Self-Check 12.6: Improving Rendering and Database Performance With Caching**

Under-17 visitors to RottenPotatoes shouldn’t see NC-17 movies in any listing. A controller filter exists that can determine if a user is under 17. What kinds of caching would be appropriate when implementing this: i. Page ii. Action iii. Fragment

(x) ii. and iii.
( ) i. and iii.
( ) iii. only
( ) i., ii., and iii.

[[Page caching will bypass the controller filter, but action caching would allow us to avoid regenerating an 'under-17-specific' view of the listings page, and fragment caching could help if we miss in the action cache.]]

---

**Self-Check 12.7: Avoiding Abusive Database Queries**

Suppose Movie has many Moviegoers through Reviews. Which foreign-key index or indices would MOST help speed up the query: "fans = @movie.moviegoers"

(x) reviews.movie_id
( ) movies.review_id
( ) reviews.moviegoer_id
( ) moviegoers.review_id

[[Because of the through-association, the query involves finding the review(s) whose movie_id matches this movie, and then for each of those, looking up the appropriate moviegoer_id. So we need an index on the movie_id field of reviews. We don't need any special index on moviegoers, since lookups by id are already indexed by default.]]

---

**Self-Check 12.9: Security: Defending Customer Data in Your App**

If a site has a valid SSL certificate from a trusted CA, which of the following are true: i) The site is probably not “masquerading” as an impostor of a real site ii) CSRF + SQL injection are harder to mount against it iii) Your data is secure once it reaches the site

(x) (i) only
( ) (i) and (ii) only
( ) (ii) and (iii) only
( ) (i), (ii) & (iii)

[[SSL assures the server's identity (if the certificate is from a trusted signing authority) and protects data while in transit to the server, but that's it.]]

---

**Self-Check 12.10: The Plan-And-Document Perspective on Operations**

Which statement regarding reliability and security is most likely FALSE?

(x) Not removing data races could violate the security principle of psychological acceptability
( ) Improper initialization of data could violate the security principle of fail-safe defaults
( ) Not checking buffer limits could violate the security principle of least privilege
( ) None are false; all are true

[[Data races describe an error related to non-determinism caused by two competing processes commonly found in systems (OS, databases, parallel computing). This is not particularly related to psychological acceptability, which refers to a more social set of conditions.]]
