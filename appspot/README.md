Managing VM images on AppEngine
===============================

Big shout out to Maggie Johnson at Google for facilitating a donation of
AppEngine credits to distribute the ESaaS courseware VM!

This is the source code for a trivial app that serves big files (VM
images, usually).

You need to download the Google AppEngine dev kit for whatever platform
you have in order to edit the app and redeploy it to Google.  You also
need to have someone who currently has Admin access *on the AppEngine
site* to grant you admin in order to do that.

The app is hosted at [http://saasbook.appspot.com].  If you visit it
and someone has made you an Admin, you will see an *Upload* button where
you can upload a new VM image file, and *Delete* buttons next to each
existing file.  Non-admins won't see these buttons (and the actions the
buttons point to are only run for admins anyway).
