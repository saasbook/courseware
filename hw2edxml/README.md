Auto-generate "edXML" pages for ESaaS homeworks
===============================================

This tool generates a homework assignment "module" for an edX course.

Each major unit in an edX course is a `chapter`.  A chapter is composed
of `sequential` elements.  A sequential is the unit of content that,
when clicked, shows the horizontal nav ribbon.  For the purposes of this
tool, one homework assignment module corresponds to one sequential.

Each element in a sequential's horizontal nav ribbon is confusingly called a
`vertical`.  Each vertical can be viewed just by scrolling around on a
page, and may contain one or more content elements such as HTML text,
inline multiple-choice questions, or forms for submitting to an external
autograder.

This script takes a single toplevel README.md (markdown) or HTML5 file and
converts it as follows.  Markdown files are first converted to HTML5; if
starting from HTML5, only the contents of the `<body>` element are processed.

Each toplevel heading (`<h1>`-equivalent) becomes a vertical.

Within a vertical (that is, between two `<h1>`s):

* an element with `<div class="ruql" data-display-name="Foobar">` is passed
to the RuQL edXML generator and the results are packaged as an edXML
`<problem>` element whose student-visible title will be the value of the
`data-display-name` attribute.

* an element with `<div class="autograder" data-display-name="Foobar">` will emit
a `<problem>` element that submits to an external autograder.  This
requires the presence of the file `autograder/config.yml` as part of the
homework; see below.

* any markup not enclosed in one of the above `<div>` types is collected
into an `<html>` static page element.

The result will therefore be a single sequential containing one or more
verticals, with each vertical containing some mix of HTML, inline (RuQL)
problems, and external-autograder problems.  The output is therefore a
directory structure whose toplevel is a sequential.

From the root level of the homework (the one containing the
subdirectories `public`, `solutions`, and `autograder`), run:

    `hw2edxml .`

The script will expect to find `public/README.md` for the overall
structure of the homework, and `config/autograders.yml` if any of the
components in the homework call for an external autograder.
