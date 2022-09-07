# Livecoding-friendly demos for ESaaS

This repository contains a handful of completed and partially-completed
apps suitable for doing live demos for ESaaS students, such as code
walkthroughs and the like.

The examples are arranged according to which chapter in the ESaaS
textbook they most closely correspond to.

Each subdirectory contains its own README, but here is an overview of
the examples:

# In ch02-saas

The README describes a way to do a simple HTTP demo using `netcat` and
`curl`.  In addition, there are these:

`sinatra`: a minimal "hello world" app using Sinatra, to show how a simple
framework provides basic abstractions for SaaS architectural elements,
including passing parameters in the URL, creating objects to return to
the client, etc.

`sinatra-sessions`: How session data is preserved by serializing it into
a cookie that is passed back to the client.

`ttt`: A 2-player tic-tac-toe game using Sinatra, built primarily to
illustrate how to think about creating simple REST APIs for network
apps.  The game is developed as a set of standalone classes that know
nothing about the Web, and Sinatra is then used to provide a server
front-end that uses those classes.

# In ch03-ruby

A number of examples illustrating Ruby features that may be less
familiar to programmers coming from imperative languages, including
collection idioms and Ruby's "everything is an object" programming
model.

# In ch04-rails

Support for creating a Rails app from scratch, indicating minimal
requirements for models, views, and controllers.  There is also an
warmup homework that provides an "on-ramp" to the autograded assignment
in which students modify RottenPotatoes to filter views in different
ways (the ["Enhancing
RottenPotatoes"
homework](https://github.com/saasbook/hw-rottenpotatoes-rails-intro)).

# In ch05-bdd-cucumber

A trivial app showing how to use Cucumber to use BDD to create a new
feature.  Detailed walkthrough instructions in the README.

# In ch08-tdd-rspec

`ttt`: A cleaned-up version of the `ttt` Sinatra app from `ch02-saas`, which
has been "gutted" of code so you can use RSpec to write specs for it.

`rottenpotatoes-rails-intro`: A copy of the starter code for the ["Enhancing
RottenPotatoes"
homework](https://github.com/saasbook/hw-rottenpotatoes-rails-intro) to
illustrate the additional functionality available in RSpec for testing
Rails apps (additional matchers to verify if particular view variables
are set correctly or whether redirects occurred; additional abstractions
to examine the contents of the session; and so on)

# In ch09-legacy

`refactoring_timesetter`: The various stages of refactoring and code
cleaning for the `TimeSetter` example used in lecture.

`refactoring_customer_opt_in`: A real-life example from another app (the
open source ticketing system
[Audience1st](https://github.com/armandofox/audience1st) of refactoring
a chunk of code that checks for a particular condition on customer
login.

