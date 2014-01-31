This folder contains updated skeletons for the homework assignments
tested on a Ubuntu 12.04 VM with Ruby 1.9.3 and Rails 3.2.15.

HW1 (hw1.zip) - No changes to skeleton downloaded from edX courseware

HW1.5 (oracle-of-bacon.zip) - No changes as above

HW2 (rails-intro.zip) - This is a zipped version of the rottenpotatoes
folder under vm-setup. Created from scratch as per book with some minor
changes. More details there.

HW3 (bdd-cucumber.zip) - Made some Gemfile changes that included the
following. Changed Rails version from 3.2.14 to 3.2.15. Added Ruby version
so Heroku would use proper version if pushed. Changed from ruby-debug to
debugger as it causes less issues. Added , :require => false to cucumber-rails
line to avoid a warning. Added rails_12factor for Heroku compatibility.
Added config.assets.initialize_on_precompile = false to application.rb
for Heroku compatibility. Updated Gemfile.lock for minor version changes.
This homework does not require push to Heroku but some may wish to do so.

HW4 (hw4.zip) - Same modifications as HW3. Some I had made earlier. Also
removed temp files ending in ~ that I had not done on the previous edit.
