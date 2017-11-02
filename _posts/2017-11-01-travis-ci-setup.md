---
layout: page
title: "Travis CI setup"
category: rails
date: 2017-11-01 17:28:04
---

This recipe should help you create a `.travis.yml` file that meets all
the following criteria (which the default configuration does not):

1. Correctly run both specs and Cucumber scenarios, and merge the
coverage results

2. Push the coverage results to CodeClimate

3. If necessary, unencrypt the secrets file `config/application.yml`
from the encrypted `config/application.yml.asc` (assuming you're
following the methodology described in this article for managing
secrets).


<script src="https://gist.github.com/armandofox/af5e340c1d95b252e82bd6831b7decac.js"></script>
