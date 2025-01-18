# ESaaS Cucumber / Capybara Templates

The `support/` directory includes some sample code that likely goes in
`features/support/` within your own app.

## Capybara Setup

### `support/browser.rb`
This file uses Capybara + Selenium to setup a common set of browsers.
It requires the `cucumber-rails`, and `selenium-webdrivers` gems.
It also requires that you have the necessary browsers installed, but only if
you try to run them.

The default is to use Chrome is _headless_ mode, which is the most common testing environment.
You will need to install `chromedriver`, e.g. `brew install chromedriver` AND the
the version of chromedriver will need to match the version of Chrome.

#### Supported Browsers / Commands
* `GUI=1` -- run in Chrome w/a GUI
* `DRIVER=safari` -- run with Safari (GUI only)
* `DRIVER=stp` -- run with Safari Technology Preview (GUI only)
* `DRIVER=firefox` -- run with Safari (GUI)
* `DRIVER="Headless Firefox` -- run with Firefox headless
* `DRIVER=chrome` -- run with Chrome (GUI, but `GUI=1` is easier.)
* `DRIVER="Headless chrome` -- run with Chrome headless (The default)

Use these as environment variables, e.g.:

```
GUI=1 bundle exec cucumber
```
