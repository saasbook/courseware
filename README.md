Courseware for Engineering Software as a Service
================================================

a/k/a UC Berkeley CS 169 Software Engineering, a/k/a CS 169.1x/169.2x on
EdX

`vm-setup` contains install scripts designed to start from a clean
Ubuntu image (see comments inside script for which Ubuntu distro) and
install all the courseware needed for the class.

Version numbers in the VM names track the earliest version of the 
[book](http://saasbook.info) with which that VM image is designed to
work; using that VM with earlier-numbered versions of the book may not
give the results the book describes.

`appspot` contains an AppEngine app deployed to saasbook.appspot.com.
Google graciously donates hosting for the VM image on a high-replication
AppEngine instance.  The app's README explains how to administer it and
upload new images there.

Installation Instructions
=========================

```sh
# Install git if you don't already have it installed 
sudo apt-get install git 

# Create a folder to clone the courseware source code 
cd ~ && mkdir CS169
git clone https://github.com/saasbook/courseware.git
cd courseware

# Run the script to install all the courseware needed for the class 
cd vm-setup
chmod +x configure-image-0.10.2.sh
./configure-image-0.10.2.sh
```