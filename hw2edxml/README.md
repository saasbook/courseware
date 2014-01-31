Auto-generate "edXML" pages for ESaaS homeworks
===============================================

This script automatically generated "edXML" pages that can be
copy-and-pasted into EdX Studio for homeworks that use an external
autograder like `rag`.

An autogradable homework consists of one or more problems.  Each problem
is a separately-submitted item (a single file, a tarfile, a URL, etc)
that is handed off to an external autograder.

This tool expects to find an autogradable homework with at least
the files
`public/README.md` and `autograder/config.yml` that conform to the
structural requirements described in the README for the `saasbook/hw`
repo. 

It also needs to have access to `autograders.yml`, a site-specific file
also described in that README.

From the root level of the homework (the one containing the
subdirectories `public`, `solutions`, and `autograder`), run:

    `hw2edxml autograders.yml`

where `autograders.yml` is the site-specific, site-wide config file for
external autograders.

You will be left with one `.xml` file for each problem in the homework.
Go into edX Studio and add a "problem" in the appropriate place in your
course; switch to the raw-HTML editor for that problem; and
copy-and-paste the contents of one of the `.xml` files directly into
it.  Repeat for each part.
