Contributed by [Dr. Genaina Nunes Rodrigues, Univ. of Brasilia](http://www.cic.unb.br/~genaina/)

<h1> Part 1: BDD Cucumber/Capybara Warm-up</h1>

This folder implements some features of the RottenPotatoes website. Run cucumber on feature/AddMovie.feature and check if the scenario outcome is "green as a cucumber!". If not, make the appropriate fixes and make it green!

Make sure you have studied Chapters 4 and 7 on ESaaS book and follow the screencast on <a href= http://youtu.be/-wgZXDmhRw4> this is the demo I did in class </a> and <a href= http://youtu.be/wornoChkjfM> this other one </a>, both from ESaaS authors.

<h1> Part 2: Ruby/Rails Warm-up</h1>

1) Make Movie Title and Release Date clickable links.

a. General idea: use link_to to create a link in your view.
http://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to
In your URL, you should use the route that routes to index.html, action index. (do rake routes to see the routing table). Inside the URL, pass a hash that has a symbol as a key and a value of a string (e.g. :sort_by=>”title”). By doing this, in the controller, you can say params[:sort_by] and get out “title”. The link should also have an id associated with it. Id should be a symbol. This should be assigned to “title_header” or release_date_header.

At this point, reload your page in your browser—you should have 2 links in your table header. Watch for errors being reported by rails server!! If you have syntax errors, they will start showing up there.

b. Now, edit your controller. If you click one of the links, notice how the URL changes. The information after the ? is accessible via params. For example, if the URL says ....?sort=”title”, you can look at params[:sort] to get out “title.”

c. For sorting, keep in mind that you are not updating the table—you’re simply changing the find command. In the original code, you have Movie.all. This gives you all movies. Specifically, you want to change the order. There are a number of ways to do this. First: http://apidock.com/rails/ActiveRecord/Base/find/class Notice the part to change the order. A simpler way is to take advantage of metaprogramming using the order method.

d. CHECK YOUR WORK! Reload your site: localhost:3000/movies If it’s working, git commit then git push. Otherwise, debug!!!

e. Now you can change the CSS. Changing the css changes how the view looks. In standard html, you’d say something like <p class=”hilite”> This means find the code for hilite and apply it to this element. In haml, it’s very similar: %p{:class=>”hilite”} You do not want hilite to be hardcoded in though—set an instance variable in your index method of the controller to say that the variable should be set to “hilite” or nothing. Use that instance variable in your view to change the class. If it’s nothing, then nothing will change. To insert the CSS information, paste this simple CSS into RottenPotatoes' app/assets/stylesheets/application.css file.

f. CHECK YOUR WORK! Reload your site: localhost:3000/movies If it’s working, git commit then git push. Otherwise, debug!!!
