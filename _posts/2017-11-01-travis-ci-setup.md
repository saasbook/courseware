---
layout: page
title: "Travis CI setup"
category: rails
date: 2017-11-01 17:28:04
---

This recipe should help you create a `.travis.yml` file that meets all
the following criteria (which the default configuration does not):

1. If necessary, unencrypt the secrets file `config/application.yml`
from the encrypted `config/application.yml.asc` (assuming you're
following the methodology described in this article for managing
secrets).

2. Correctly run both specs and Cucumber scenarios, and merge the
coverage results (by default, you'd only see coverage data for whichever
set of tests is run last)

3. Push the merged coverage results to CodeClimate


# Prerequisites

You should have a Travis CI account configured to do builds on your
project, and a CodeClimate account configured to do code analysis.  This
recipe shows how to also merge test coverage information from both RSpec
and Cucumber tests so that CodeClimate can track and display that
information. 

The part of the example file below that refers to
`config/application.yml` assumes that you are using the method 
[described in this recipe]({{ site.baseurl }}{% post_url 2017-11-01-managing-api-keys %})
to manage sensitive data such as API keys; if you're not, you should
comment out that line and replace it with whatever commands are
necessary (if any) to give Travis CI access to such information.


<script src="https://gist.github.com/armandofox/af5e340c1d95b252e82bd6831b7decac.js"></script>
