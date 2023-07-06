# SaaS/Sinatra demos

## HTML and CSS (directory `html-css`)

The file `simplified-bootstrap-template.html` is based on a simplified
version of one of the templates found at `getbootstrap.com`.  Some
things to notice:

* The first line `<!doctype html>` declares the document type.  HTML
has gone through a number of revisions, and `<!doctype html>` refers
to HTML 5.  Other values instead of `html` can be used to indicate a
page that complies with an older version of the standard.

* The entire HTML document consists of a single element `<html>` (find
the closing tag `</html>` at the end).  The general structure in terms
of nested elements is:

  html
    head
      link  (optional tags for stylesheets)
      script (optional tags to pull in JavaScript code)
      meta   (optional tags containing info about the page itself)
      title  (optional page title, displays in browser's window titlebar)

    body
      (various HTML elements making up the page body)

* In this case, the `<link rel="stylesheet">` tag loads the Bootstrap
CSS stylesheet directly from Bootstrap's own servers.  (We'll learn
what the `integrity` and `crossorigin` attributes refer to later in
the course.)  There is also
an additional stylesheet `custom.css` that can selectively override
some styles in the Bootstrap stylesheet, because it is loaded later.
This is a common pattern: load a basic stylesheet and selectively
customize or add a few elements of your own.

* Install the Web Developer Extension for your browser (it's available
for Chrome, Firefox, Safari, IE, and many others), and while viewing
the page, try temporarily disabling all styles.  This lets you see how
CSS can affect the visual layout of the page without any changes at
all to the page's HTML.  Note especially the ability to lay out the
tiles (cards) in a grid; what happens to the grid when styles are
disabled?

* Try finding some elements with borders in the
example, and using Bootstrap's online documentation, change them to
have borders on all four sides.

* Try making the prices of each plan display in a different color,
such as red.  (Hint: notice what CSS class(es) are applied to those
elements, and override those classes in `custom.css` to achieve the
effect you want.)

* Harder: Try making the list of features on each card display in
another color.  Hint: add a CSS class to the `<li>` elements
and then write a CSS rule in `custom.css` to style elements of that class.

Main takeaway: HTML tags represent "low level" elements such as
paragraphs, list items, headings, etc.  Bootstrap gives you "higher
level" components such as cards, navbars, etc., and lets you add
borders to elements 


## HTTP plumbing basics

* HTTP via Netcat. Show just returning simple text to display in browser (`nc -l 8000` and point browser at `localhost:8000/helloworld`)
  * *NOTE* If using Cloud9, you can't point cloud9's browser at it,
  because the network mapping they do makes `localhost` not mean what
  you think it means.  However, you can open a second terminal window in
  Cloud9 and say `curl 'localhost:8000/helloworld'` and that will work.
  `curl` is a command-line utility that acts as an HTTP client--like a
  browser, except it can just dump results to a file but not display
  rich media.)
  * Why localhost:8000?
  * Why `helloworld`? Where does this info appear in the request? What if we said `hello/you/world` instead of `helloworld`?
* But HTTP is more than this. Show inbound headers from browser, then outbound headers from a typical server; show content-type, length, etc.
  * `curl -i https://cs.berkeley.edu | more` or `curl -I  https://cs.berkeley.edu` to see headers only
  * Server response includes headers and data; client request seems to include only headers. When might client request also include data? (Answer: when submitting a form)
* If HTTP error, show that headers indicate an error, but it's an app level error, not HTTP error: `curl -i https://cs.berkeley.edu/we_love_stanford`
* Contrast with a network-level error, eg `curl https://cs.stanfurd.edu`

## Sinatra "Hello World" demo with views and controller (directory `sinatra`)

* Sinatra hello-world demo: `bundle` then `rerun rackup` and point browser at `localhost:9292` (why port 9292?)  
  * Note which tasks the framework now handles: URL parsing, "packaging up" stuff to send back to browser with proper headers, etc.
  * Change one of the URL handlers to something like:
```ruby
get '/set/:something' do
  "Hello #{params[:something]}"
end
```
  * Now we see that Sinatra handles simple URL patterns and creates a nice hash for you called `params`.
  * Refer to the "SaaS stack" picture in Ch 2 lecture slides; identify Rack+Sinatra as the app server, WEBrick as the HTTP server
* Show MVC slide; Sinatra is a micro-framework that gives you Controller and Views, but doesn't say anything about Models.  In contrast,
Rails has strong opinions about what a model is.  
* To see a view, change body of one of the handlers to `erb :hello`, and edit `views/hello.erb`.  Show how interpolated variables are available
to the view, e.g. `<%= @something  %>`.  
  * When we set an instance variable in the controller method, of what class is it an instance variable? (Answer: of our app, which inherits from `Sinatra::Base`)
  * How is it that controller instance variables are available to the view?  (Answer: it violates OOP orthodoxy, but Sinatra designers 
  chose to do it because it makes it easy/pleasant for developers to handle common case of having controller set up some data to be 
  displayed in the view.)

However, what happens if we do `GET /set/foobar` and then just `GET /`?
Why isn't the variable persisted?  This leads in to Cookies.
  
## Cookies:  if we want to save info across requests (directory `sinatra-sessions`)

* See cookie arriving from Google.com: `curl -I http://www.google.com`
* See outgoing cookie from Localhost: run `nc -l 8000`, point browser at `localhost:8000` and notice `Set-Cookie` header. It's browser's
job to store/remember these cookie values, and send the correct one to each site when you visit that site.  To verify, disable cookies
in your browser (method varies) and repeat this process; there should be no cookie header. The browser still has the cookie stored 
for `localhost`, but disabling cookies suppresses including the cookie in the header.
* How does Sinatra framework support cookies? Turn on Session gem in sinatra. Now we get an "automagical" hash that we can put
stuff in and it persists across requests!
* The session hash is a _leaky_ abstraction: it may not work the way you expect if you are totally oblivious to the implementation.  How could it go wrong?
  * User disables cookies - nothing you can do
  * User can "interpret" what's in cookie and tampers with it, e.g., trying to make it appear they're logged in as someone else. Solution: 
  Cookies are usually encrypted with a secret that only the server knows, which also makes them tamper-evident
  * Cookie length exceeds 4KiB, a limit set by HTTP specification - cookie may be mangled since it represents a serialized and possibly encrypted 
  object, so if truncated it's not reconstituted.  To solve, usually the server remembers most per-user state in a database, and the session 
  just holds a "handle" or some kind of ID to recall that state.
  

## RESTful thinking (directory `ttt`)

One way to use these demos interactively is to clone the repo, switch to
a scratch branch, and delete a lot of the code, then fill it back in as
a group activity.

Suppose we want to do a RESTful TicTacToe (noughts and crosses) game.

* What resource(s) would the app manipulate?
  * Main resource is the game itself
  * Operations: start new game; place X or O on a square; check if game over or win
  * `tic_tac_toe.rb` has simple implementations of the above
* To SaaSify the app, must choose routes for the actions, and identify what state must be persisted.

What RESTful routes do we want?

* New game: POST, since changes state
* Show game state: GET
  * If game over, disallow further moves, but allow starting new
  * Otherwise, display whose turn it is, and accept input for move
  * Since this is most common operation, no reason not to make it root URL '/'
* Make a move: POST
* Neat extra: checking for win can be done using a collection idiom (see
comment in `tic_tac_toe.rb`):
```ruby
win_patterns.any? { |squares| squares.all? { |sq| @board[sq] == player }}
```

How to preserve game state? Can we just persist the actual game object in session? Yes, but in general we'd use a database and just persist an identifier in the session.
  * In this case, serialized object is small; `require 'yaml'` and then do `YAML.load(YAML.dump(TicTacToe.new))` to demonstrate
  * Cookies are encoded using Base64 encoding to encode the hash and some other metadata; `require 'base64'` and `Base64.decode64(Base64.encode64('string'))` to demonstrate

Show use of debugger to inspect `session[:game]` at start of a controller method.

* Discussion of which routes are appropriate for which actions.  See
`questions.txt` for some interactive discussion questions about this.
  * Key point: route = verb + URL, and every route is independently
  recognizable.  Routes, not URLs, map to actions.  We decide mapping.

* For the show board action, what can the user do once board is shown?
We need to enable some interaction here.  Correct interaction depends on
whether game is over or it's someone's turn.  
  * Key point: mapping between the `action=` attribute of `<form>` and
  the route and params we will get in the controller action (ie name of
  input field).

## Crash intro to RSpec and Cucumber

* What are some things we expect to be true about a newly initialized
game?
  * Do the cases for whose turn it is, board empty, etc, then group them
  with a before-each to DRY out the test setup

