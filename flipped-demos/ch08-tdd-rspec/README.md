# RSpec exercise 1: simple specs (directory `ttt`)

This directory contains a cleaned-up and slightly more idiomatic (in
some ways) version of the TicTacToe game from `ch02-saas` directory.
Running `bundle` will set you up to use `autotest`, keeping it running
the whole time as specs are added.

Suggested use: have students check out the 'gutted' version of this game
and spec:

`git clone -b ch08-work https://git@github.com/saasbook/flipped-demos`


0. Print out the contents of `tic_tac_toe_spec.rb` for your reference
0. Switch to a scratch branch, and gut all the specs by
eliminating the `do` blocks and the `describes`, so that only "bare"
`it` clauses remain.  Or even better, start building up the `it` clauses
one by one.
0. Ask students to pair up and write each spec, then go over the spec
together.  
  * After the "new game" specs, point out the opportunity to pull
out `@game = TicTacToe.new('o')` into a `before(:each)` block, but point
out that we must then use an instance variable `@game` rather than a
local variable, so that the instance variable's value is visible to the
various cases.  Advanced students may be curious to know what type of
object it's an instance variable of; the answer is that it's an instance
variable of `Rspec::ExampleGroup`, the class that represents a group of
examples.  Recall that unlike Java, a class in Ruby does not predefine
the set of allowed instance variables; any instance of the class can
create its own instance variables without permission.
  * When doing the specs for exceptions, ask why the argument to
  `expect` must be in curly braces rather than parentheses. (The answer
  is that the curly braces make the argument a procedure, and when
  `expect` receives a procedure argument, it calls the procedure and
  catches any exceptions.  This allows us to write specs that test
  whether an exception was in fact raised.)

0. When creating the specs "verifies that board is full" and "indicates
NO win if board is full", again point out that the code to "fill the
board" with a non-winning game can be pulled out into a before-block,
as long as we isolate the cases that depend on that code as their own
example group.  We can do this with either a nested `describe` or with
`context`, which is just a synonym for `describe`.
  * Discussion question: why is it so complex to setup this
  precondition?  (Answer: Our tictactoe abstraction doesn't expose the
  board as a writable element.  We could choose to do that and then
  simply have a before-block that sets the board; that would be a
  glass-box test.  But that increases the risk that someone using the
  class externally can write the board.  Whether that's a reasonable
  risk is a matter of judgment.  
  * There are two Ruby tricks we could use to do this behind the code's
  back.  One is `@game.instance_variable_set(:@board, %w(o x o o x o x o
  x))`, which reaches directly into a class to set an instance
  variable.  Clearly, this shouldn't ever be done in real code.
  * The other is to reopen the class and declare a setter for the board,
  so the before block can just say `@game.board = %w(o x o o x o x x x)`:
```
class TicTacToe
  attr_writer :board
end
```


* After doing all the specs, get the students to answer this question:
what's the ratio of lines of tests to lines of code?  (They can use `wc
-l` to answer it if they have Unix command-line skills.)  How does this
compare to test-to-code ratios in industry?  (There is large variation, but
ranges of 2:1 to 10:1 are not uncommon.)

# RSpec exercise #2: rspec-rails (directory `rottenpotatoes-rails-intro`)

This subdirectory contains a copy of the starter code for the ["Enhancing
RottenPotatoes"
homework](https://github.com/saasbook/hw-rottenpotatoes-rails-intro) to
illustrate what additional RSpec functionality is provided by the
`rspec-rails` gem to help specifically with the testing of Rails apps.

An important message here is that these are simply extensions to the
core RSpec framework that understand the inner workings of Rails.  For
example:

* rspec-rails defines methods `get`, `put`, `post`, etc. (HTTP verbs),
which take an action name and optional `:params => { }` argument to
cause the right controller action to be called with parameters,
bypassing the routing system that maps URLs and parses `params` from
them.  This allows controller methods to be tested separately from the
routing, so controller specs do not break if routing changes.

* rspec-rails "knows" that all controller actions must either redirect
or render something.  To avoid having controller specs depend on whether
the redirect or render happens successfully, `rspec-rails` defines the
matchers `redirect_to` and `render_template`.

# Debugging exercise

You can group-debug four bugs, or any subset of them.

## Bug #1: missing route

Apply the following patch to `config/routes.rb` (`patch -p1` then paste the below):

```
diff --git a/config/routes.rb b/config/routes.rb
index faacdaa..364866f 100644
--- a/config/routes.rb
+++ b/config/routes.rb
@@ -2,8 +2,6 @@ Rails.application.routes.draw do
   # The priority is based upon order of creation: first created -> highest priority.
   # See how all your routes lay out with "rake routes".
 
-  # You can have the root of your site routed with "root"
-  root 'movies#index'
 
   # Example of regular route:
   #   get 'products/:id' => 'catalog#view'
```

This removes the root route, so going to the RottenPotatoes root route
will show the Rails landing page.  Debugging consists of asking "Where
is the root route defined?" and re-inserting the deleted lines,
possibly after consulting the Rails Routing Guide.

## Bug #2: near-syntax-error in a controller action

In `movies_controller.rb`, change the first line of the `show` action
to say `params[id]` rather than `params[:id]`, or just paste the
following patch to `patch -p1`:

```
diff --git a/app/controllers/movies_controller.rb b/app/controllers/movies_controller.rb
index 060b067..1621b5f 100644
--- a/app/controllers/movies_controller.rb
+++ b/app/controllers/movies_controller.rb
@@ -1,7 +1,7 @@
 class MoviesController < ApplicationController
 
   def show
-    id = params[:id] # retrieve movie ID from URI route
+    id = params[id] # retrieve movie ID from URI route
     @movie = Movie.find(id) # look up movie by unique ID
     # will render app/views/movies/show.<extension> by default
   end
@@ -42,6 +42,6 @@ class MoviesController < ApplicationController
   # Making "internal" methods private is not required, but is a common practice.
   # This helps make clear which methods respond to requests, and which ones do not.
   def movie_params
-    params.require(:movie).permit(:title, :rating, :description, :release_date)
+    params.require(:movie).permit(:title, :description, :release_date)
   end
 end
```

The show action will throw an exception since the value of `id` will
be nil.  Debugging would either fix by inspection, or set a breakpoint
in `show` to examine why `id` has an unexpectedly  nil value, possibly
by inspecting `params[]` since that is where the value is assigned from.


## Bug #3: incorrect route triggers wrong action

This one is trickier.  In the `form_tag` call in
`app/views/movies/edit.html.erb`, change `:method=>:put` to
`:method=>:get`, or apply the following patch:

```
diff --git a/app/views/movies/edit.html.erb b/app/views/movies/edit.html.erb
index 47fdcdf..38cffa2 100644
--- a/app/views/movies/edit.html.erb
+++ b/app/views/movies/edit.html.erb
@@ -1,5 +1,5 @@
 <h2>Edit Existing Movie</h2>
-<%= form_tag movie_path(@movie), :method => :put do %>
+<%= form_tag movie_path(@movie), :method => :get do %>
   <%= label :movie, :title, 'Title', :class => 'col-form-label' %>
   <%= text_field :movie, 'title', :class => 'form-control' %>
   <%= label :movie, :rating, 'Rating', :class => 'col-form-label'  %>
```

Demonstrate that when you edit a movie and click Update, (a) the
update does not seem to take and (b) you are sent back to the movie's
detail page, _not_ the list of movies as expected.

The first debugging hypothesis  might be to set a breakpoint in the
`update` action, but you can quickly show that the breakpoint doesn't
get hit, and that therefore the hypothesis must change to "the wrong
action is being called".  This should lead you on a search of the form
"What route **would** call the update action?" (resolved by viewing
routes file) followed by "And what route is **actually** being
generated by the edit form?" (resolved by looking at the HTML source
initially and noticing that the `<form>` tag has `method="get"`,and
subsequently by looking at the code in the `edit.html.erb` view and
noticing that the `form_tag` call has the wrong `:method` keyword
arg).

You also have to remind people that `:method => :put` will actually
show up as `POST` method in the HTML source, because browsers can only
generate `GET` and `POST` but Rails internally converts it to a `PUT`
(this is described in the Routes section of ESaaS).

Once the view has been fixed, emphasize that rather than "re-running"
the whole flow, you can back up to your previous hypothesis ("the
update action is buggy")  and now at least verify using the debugger
that that action is reached.

## Bug #4: forgotten `params[:permit]` causes some attributes not to be updated

In the `params.permit` call at the bottom of the movies controller,
remove the `rating` parameter.  Or apply the following patch:

```
diff --git a/app/controllers/movies_controller.rb b/app/controllers/movies_controller.rb
index 060b067..1621b5f 100644
--- a/app/controllers/movies_controller.rb
+++ b/app/controllers/movies_controller.rb
@@ -1,7 +1,7 @@
 class MoviesController < ApplicationController
 
   def show
-    id = params[:id] # retrieve movie ID from URI route
+    id = params[id] # retrieve movie ID from URI route
     @movie = Movie.find(id) # look up movie by unique ID
     # will render app/views/movies/show.<extension> by default
   end
@@ -42,6 +42,6 @@ class MoviesController < ApplicationController
   # Making "internal" methods private is not required, but is a common practice.
   # This helps make clear which methods respond to requests, and which ones do not.
   def movie_params
-    params.require(:movie).permit(:title, :rating, :description, :release_date)
+    params.require(:movie).permit(:title, :description, :release_date)
   end
 end
```

Now, updating the movie attributes will fail to update the rating.
Point out that unless you had a specific CI test for this, it would be
easy to overlook that it's a bug!

Debugging consists of using the interactive debugger to eventually
zero in on the fact that the argument list actually being passed to
`Movie#update_attributes!` is missing a parameter, and that that is
due to `movie_params()` returning an incomplete parameter list.


## Walkthrough of TDD for adding TMDb support to RottenPotatoes app

* Start with a scratch branch checkout of the
`rottenpotatoes-rails-intro` repo. 
* `bundle install --without production` to ensure all gems installed
* Setup `guard` gem to automatically re-run specs by doing `guard
init`.  Since we specified `guard-rails` gem, default configuration
watches specfiles in `spec/` directory.
* Setting up TDD for the controller action:
  * Add a route to config/routes.rb: `post '/movies/search_tmdb'` (could
  also be GET)
  *Create an empty view: `touch app/views/movies/search_tmdb.html.haml`
  * Add empty method in `movies_controller.rb`: `def search_tmdb ; end`

