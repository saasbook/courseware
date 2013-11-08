Created a new script for Ubuntu 12.04 LTS and VM based on the 0.10.2 script
and VM instructions located at the below address. Also, created a version
of rottenpotatoes for the VM from scratch as per book. This has been tested
with all homework of CS-169.1x including submission to grader.


VM creation details
===================

Created based on

http://beta.saasbook.info/bookware-vm-instructions

Under the section

(Unsupported) To download a smaller “blank” VM image and set it up yourself

The following is a summary of what I did to create the VM and script and why
I did so the way I did.

- Used the 32-bit Ubuntu 12.04 image from http://www.ubuntu.com/download/desktop
- Installed with updates and 3rd party options and did updates after install.
- Chose not to set root password as it seems unnecessary and not recommended.
- Removed OpenOffice and Ubuntu One icons from launcher and added Terminal and
  Gedit icons.
- Set Gedit as default editor with "sudo update-alternatives --config editor"
- Added Web Developer Addon to firefox from 
  https://addons.mozilla.org/en-US/firefox/addon/web-developer/
- Change terminal to run command as a login shell under edit > Profile Preferences
  so that it would run the bash_profile and RVM and rails would work properly.
- Retrieved 0.10.2 and made changes listed below.
- Ran with . configure_image.sh
- Deleted script and log
- Added Chromium icon to Launcher
- Created rottenpotatoes from scratch for testing and to have available as per
  screencast.
- Created final image as above only with new script and downloading previously
  created rottenpotatoes. May wish to create smaller image without Ubuntu updates.


Rottenpotatoes creation details
===============================

Created based on book chapter 4 and Appendix A with the following modifications.
Chose debugger gem instead of ruby-debug as it causes less issues.
Added rails_12factor to Gemfile for Heroku.
Added config.assets.initialize_on_precompile = false to application.rb for Heroku.
Added Ruby version to Gemfile for Heroku.
Uncommented rubyracer in Gemfile.


Script creation details
=======================

Added commands to get password and function to use it on sudo commands.
This reduces the number of times password needs entered. RVM still needs it
twice and the Heroku script needs it entered as well.

Changed all sudo commands to use the sudo-pw function.

Added set -v/+v to echo some commands, helpful for debugging and determining
what may have failed during installation due to network errors or other issues.

Added command to send stdout and stderr to a logfile for debugging etc.
Also added commands to restore stdout and stderr.

Added commands to add .profile to .bash_profile as recommended by RVM install.

Changed source /home/ubuntu/.rvm/scripts/rvm to ~/.rvm/scripts/rvm

Added command to reload bash_profile after RVM install so rvm and gem commands
would be found and work.

Added rvm rvmrc warning ignore allGemfiles to supress warning when changing to
directories containing Ruby version in Gemfile.

Changed Rails version to 3.2.15 since cucumber rails install would change this
anyway. Made version changes to cucumber and other gems. Mostly minor version
changes.

Commented out cucumber-rails-training wheels gem as it installs Rails 4.0.1 and
can just be added to Gemfile and installed with bundle install without this
issue.

Added Heroku install command which works with 12.04
