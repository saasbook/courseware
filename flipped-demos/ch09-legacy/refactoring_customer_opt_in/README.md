# Customer opt-in code from [Audience1st ticketing
software](https://github.com/armandofox/audience1st)

Goal: when customer first logs in, see if they recently opted out of email.

If yes, show a nice message encouraging them to opt back in.

Controller instance method `current_user` (actually a mixin) returns the
currently logged-in user as an ActiveRecord model instance.

# before.rb - the original code

Problems:

* mixes levels of abstraction
* exposes implementation details of how we compute whether customer needs to see this message (ie of what "opted out of email" means)
* how do we know what `flash[:notice]` was coming in?  if it was non-nil,  this will never do anything - yet now requires us to know this.
* what we really want is once per login - this code doesn't do that

# after.rb - Revised version


