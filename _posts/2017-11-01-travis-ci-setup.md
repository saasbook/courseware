---
layout: page
title: "Travis CI setup"
category: devops
date: 2017-11-01 17:28:04
---

This recipe should help you create a `.travis.yml` file that meets all
the following criteria (which the default configuration does not):

1. If necessary, unencrypt the secrets file `config/application.yml`
from the encrypted `config/application.yml.asc` (assuming you're
following the methodology described in 
[this post]({% post_url 2017-11-01-managing-api-keys %}) for managing
secrets).

2. Correctly run both RSpec specs and Cucumber scenarios, and merge the
coverage results (by default, you'd only see coverage data for whichever
set of tests is run last)

3. Push the merged coverage results to CodeClimate

# Prerequisites

You should have:

1. A CodeClimate account configured to do code analysis on your repo.
Log in to that account and grab the value of your CodeClimate Test
Reporter ID--you will need it in the below setup.

2. A Travis CI account configured to do builds on your
project.  Log in to that account and set the environment variable
`CCKEY` to the value of your CodeClimate Test Reporter ID.

# What to do

Make sure your `.travis.yml` is checked into version control and
mostly matches the following.
The line that refers to
`config/application.yml` assumes that you are using 
[this recipe]({{ site.baseurl }}{% post_url 2017-11-01-managing-api-keys %})
to manage sensitive data such as API keys; if you're not, you should
comment out that line and replace it with whatever commands are
necessary (if any) to give Travis CI access to such information.

Now, when you push to a branch, your Travis build will collect and
report coverage information to CodeClimate.  Note that coverage
information isn't meaningful unless all tests pass.

<script src="https://gist.github.com/armandofox/af5e340c1d95b252e82bd6831b7decac.js"></script>
