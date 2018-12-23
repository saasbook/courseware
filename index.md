# Recipes

This article base contains "recipes" of procedures and code snippets
for handling day-to-da processes that may otherwise present obstacles
to students in ESaaS.

This article uses Jekyll and GitHub Pages to maintain a publicly
accessible site at [saasbook.github.io/courseware].

## Contributing

1. Make sure you have [Jekyll installed](https://jekyllrb.com/docs/)

2. Fork the repo `github.com/saasbook/courseware`

3. Change to the `gh-pages` branch

4. Create a new Markdown (`.md`) file in the `_posts` subdirectory containing your
recipe.  The frontmatter (first 6 lines) **must** look like this:

```yaml
---
layout: page
title: "Name of your recipe"
category: rails
---
```

For `category` you should use whichever existing category on the
Recipes page is most appropriate.  Contact the repo owner if you feel
a new category must be created.

5. If the post refers to other posts, be sure you follow Jekyll's
instructions for creating internal links -- don't hardcode absolute
URLs.

6. As instructed  [here](https://jekyllrb.com/docs/), run `jekyll
serve` or `jekyll build` to rebuild the site and ensure your content
renders properly.

7. Commit your changes on a branch other than `gh-pages` and then do a
pull request to the `gh-pages` branch on the upstream repo.
