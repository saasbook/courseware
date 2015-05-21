Auto-generate "edXML" pages for ESaaS homeworks
===============================================

This tool generates a homework assignment "module" for an edX course,
using the structure defined for such homeworks.

From the root directory of a homework assignment, run the script with no arguments.
It looks for `public/README.md` (and `config/autograders.yml` if any of the
components in the homework call for an external autograder).

Each major unit in an edX course is a `chapter`.  A chapter is composed
of `sequential` elements.  A sequential is the unit of content that,
when clicked, shows the horizontal nav ribbon.  For the purposes of this
tool, one homework assignment module corresponds to one sequential.

Each element in a sequential's horizontal nav ribbon is confusingly called a
`vertical`.  Each vertical can be viewed just by scrolling around on a
page, and may contain one or more content elements such as HTML text,
inline multiple-choice questions, or forms for submitting to an external
autograder.

This script takes a single toplevel README.md (markdown) file and
converts it as follows.

Each toplevel heading (`<h1>`-equivalent) becomes a vertical.

Within a vertical (that is, between two `<h1>`s):

* an element with `<pre class="ruql" data-display-name="Foobar">` is passed
to the RuQL edXML generator and the results are packaged as an edXML
`<problem>` element whose student-visible title will be the value of the
`data-display-name` attribute.

* an element with `<div class="autograder" data-display-name="Foobar">` will emit
a `<problem>` element that submits to an external autograder.  This
requires the presence of the file `autograder/config.yml` as part of the
homework; see below.

* any markup not enclosed in one of the above `<div>` types is collected
into an `<html>` static page element.

The result will be a `studio/` directory containing subdirectories
`sequential`, `problem`, `vertical`, `html`.  Copy the contents of each
of these subdirectories into the corresponding subdirectories in a
course exported from Studio.  There will be a single Sequential so a
single new module in your left-hand navbar.

