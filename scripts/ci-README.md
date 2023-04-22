# WARNING: Do not just drop the ci.yml file in your repo. Read and understand this first.

This file can be _tailored_ to other CI needs, but it is a working
example of a CI workflow that does the following on each push:

* If necessary, make secrets file available to Rails app
* Set up the CodeClimate test coverage reporter before tests are run
* Run all RSpec tests, capturing coverage
* Run all Cucumber tests, capturing coverage
* Combine the coverage info from both suites and send it to CodeClimate, so that the CodeClimate coverage badge can be served

Depending on the current state of your app, you may decide to just
merge portions of this file with your existing CI workflow, or
customize this file and use it in place of the existing one.  Check
with your coach if not sure which approach is best.

## GitHub Secrets

You should set up the following [app-wide secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets) on your team's repo:

`CCTR_ID`: Once you have linked your team repo to CodeClimate, set this secret's value to the [CodeClimate test coverage ID](https://docs.codeclimate.com/docs/finding-your-test-coverage-token).

`RAILS_MASTER_KEY`: There are (at least) two popular ways to manage app secrets (API keys, etc.). If your app uses [Rails secrets based on credentials.yml.asc](https://guides.rubyonrails.org/security.html#custom-credentials), set the value of this secret to the secret used to encrypt the credentials file.  Each team member will also (on their cloned repo) need to _either_ set `RAILS_MASTER_KEY` to this value during each work session, _or_ have a file `config/master.key` (**which must not be checked in**) containing the value.  You should also **delete** the step `make secrets available` from the workflow file, since that step is not needed with this method of secret storage.

If your app is older and uses a different file for secrets
(for example, the Figaro plug-in, which was a popular way to manage
secrets before Rails 5, looks for a file called
`config/application.yml`), you need to set `RAILS_MASTER_KEY` to the
value of the key needed to decrypt that file, and edit the `make
secrets available` step to match your app's secrets filename.  The
step as provided assumes that there is a versioned file
`config/application.yml.asc` that is encrypted, from which an
unencrypted temporary file `config/application.yml` is created for use
during the CI run (and is deleted immediately afterwards).

## Test database

The sample CI workflow does not attempt to install or start up a
database, assuming instead that Sqlite3 can be used for CI.  If that
is not the case, you'll need to add step(s) to the workflow above to
install and start Postgres or whatever the app expects the test
database to be, and remove the step `create test database configuration`.

If using Sqlite3 is OK, you should not version your
`config/database.yml` file if it contains (e.g.) information needed to
log in to the app's production database.  Since the test database used
in CI is a throwaway, instead you can version a file
`config/database.yml.test` that contains only the information for
configuring a Sqlite3 database in the `test` environment, like this:

```yaml
test:
  adapter: sqlite3
  database: db/test.sqlite3
```

The `create test database configuration` step in the CI workflow
copies the contents of this file to `config/database.yml` so it gets
used for the test run.

