# Walkthrough of TDD for adding TMDb support to RottenPotatoes app


* Start with a scratch branch checkout of the
`rottenpotatoes-rails-intro` repo

Add to `app/views/movies/index.html.erb` a form above the table:

```
<%= form_tag search_tmdb_path, :method => 'get', :class => 'form form-inline' do %>
<%= text_field_tag 'search_terms', 'Search for movie title', :class => 'form-control col-md-8' %>
  <%= submit_tag 'Search TMDb', :class => "btn btn-primary form-control col-md-3" %>
<% end %>
```

What happens when form submit?  Error because no route matches
`search_tmdb_path` helper, so add a route to config/routes.rb: 

  `get '/movies/search_tmdb', :as => 'search_tmdb` 

Now submission fails because no controller action, so add empty method
in `movies_controller.rb`: `def search_tmdb ; end` 

Now fails because there is no view to render, so create an empty view:
`touch app/views/movies/search_tmdb.html.erb` 

Now we can start writing tests.  Create
`spec/controllers/movies_controller_spec.rb` containing 

```
require 'rails_helper'

describe MoviesController do
  describe 'searching TMDb' do
    it 'calls the model method that performs TMDb search, and passes the correct search string' do
      expect(Movie).to receive(:search_in_tmdb).with("Bodies Bodies Bodies")
      get 'search', {"utf8"=>"✓", "search_terms"=>"Bodies Bodies Bodies", "commit"=>"Search TMDb"}
    end
    it 'selects the Search Results template for rendering'
    it 'makes the TMDb search results available to that template' 
  end
end
```

Walk through writing the first test case a line at a time.
