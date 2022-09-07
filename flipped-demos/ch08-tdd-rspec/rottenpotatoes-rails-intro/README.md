# Walkthrough of TDD for adding TMDb support to RottenPotatoes app

* Start with a scratch branch checkout of the
`rottenpotatoes-rails-intro` repo
* Setting up TDD for the controller action:
  * Add a route to config/routes.rb: `get '/movies/search_tmdb'` (could
  also be POST)
  *Create an empty view: `touch app/views/movies/search_tmdb.html.haml`
  * Add empty method in `movies_controller.rb`: `def search_tmdb ; end`

