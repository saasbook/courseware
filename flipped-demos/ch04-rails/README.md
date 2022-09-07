# Rails

* Make a Rails app from scratch: something like RottenPotatoes 
  * `rails new rottenpotatoes`
  * 3 environments
  * What need for a model?  
    * Model file
    * DB table? Only for AR-based models; if   table, then also need
    migration (**code generation**)
    * Apply the migration
* ActiveRecord
  * **Code generation:** Scaffold CRUD for a movie.  Point out that scaffolds are more useful
  for quickly playing around with something and understanding how parts
  work together; usually just as much work to replace scaffold as create
  things from scratch
  * Strong parameters - show effect on `params[]` hash.  Discuss
  separation of concerns - controller mediates interaction with user.


Trip through creating, updating, viewing

* Use of redirect after create/update - idiomatic
