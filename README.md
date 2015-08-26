Courseware for Engineering Software as a Service
================================================

a/k/a UC Berkeley CS 169 Software Engineering, a/k/a CS 169.1x/169.2x on
EdX

This repo contains information useful to instructors (and arguably
students) using the [ESaaS](http://www.saasbook.info) course materials.

`vm-setup` contains instructions on setting up an environment in which
to do the work.  Our recommended approach is to use
[Cloud9](http://c9.io), for which we provide instructions, but we also
provide scripts designed to start from a clean
Ubuntu image (see comments inside script for which Ubuntu distro) and
install all the courseware needed for the class.  This can be used,
e.g., on a clean install of Ubuntu on your personal computer, or on
Amazon EC2 or another cloud computer.

We no longer
distribute prepopulated VM images.

The Wiki contains information on each of the autogradable homeworks,
which are public repos named `saasbook/hw-*`.  (The corresponding
private `saasbook/hw-*-ci` repos contain the autograder files and
reference solutions for each homework.)
