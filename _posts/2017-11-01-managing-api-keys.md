---
layout: page
title: "Managing API keys"
category: rails
date: 2017-11-01 17:29:30
---

We distinguish two kinds of data: configuration-level data that is
specified once for the whole app (for example, an API key for the app to
access another microservice), and sensitive app-level data (for example,
a password or other secret that needs to be stored for each user).  
This recipe describes how to store configuration-level secret data; a
[separate post]({{ site.baseurl }}{% post_url 2017-11-01-storing-sensitive-data %}) builds on this one to store app-level secret data.

# Prerequisites

You'll need the Figaro gem and a command-line-friendly installation of
GPG for encryption.

# Use Figaro

For managing sensitive config data such as API keys, here's a
methodology that observes two important guidelines: 

* DRY: the secret data
should be kept all in one place and nowhere else.  

* Sensitive data should
never be checked into version control (eg GitHub), especially if the app
is otherwise open source.  

First, set up your app to use the
Heroku-friendly [Figaro](https://github.com/laserlemon/figaro) gem to
manage the app's secrets. In brief, Figaro 
uses the well-known technique of accessing your app's sensitive config
data as environment variables, but it simplifies the task in two ways.
First, it centralizes all secrets in a file
`config/application.yml`.
Second, it lets you access the values through a proxy object,
so that environment variable `FooBar` can be accessed as
`Figaro.env.FooBar`. This allows you to stub/override certain config
variables for testing if you want, and also (more importantly) to
specify different values of those variables for production environment
vs. development. For example, many microservices like Stripe let you
setup two different API keys--a regular key, and a "testing" key that
behaves the same as a regular key but no financial transactions are
actually performed. Using Figaro, your app doesn't have to know which
key it uses, because the correct key values for each environment can be
supplied in `application.yml` When you setup Figaro, it correctly adds
`config/application.yml` to your .gitignore, since this file containing
secrets should not be versioned (at least not in cleartext).  

# Encrypt and version your secrets file

Next, agree with the rest of your team on a symmetric key for encrypting
the secrets file. You can then encrypt the file like so (this example
uses GPG and the bash shell):

```bash
export KEY=your-secret-key-value gpg --passphrase "$KEY" \
  --encrypt  --symmetric --armor \
  --output config/application.yml.asc config/application.yml
```

This will create the ASCII-armored encrypted file
`config/application.yml.asc`, which you can then check into version control.
Note that the security of this file relies on having chosen a good
symmetric-encryption key.

# Make sure developers on the team can generate the secrets file

Of course, the `config/application.yml` file is now needed for your app to
run, but only `config/application.yml.asc` exists in the repo. So any
developer who clones the repo needs to know the value of `$KEY`, and when
they clone the repo, they must manually create the secrets file from its
encrypted version by performing the decrypt operation:

```bash
export KEY=your-secret-key-value 
gpg --passphrase "$KEY" --decrypt \
   --output config/application.yml config/application.yml.asc
```

# Make sure Heroku knows the secrets

Figaro arranges to make all the info in config/application.yml available
as environment ("configuration") variables on Heroku. Whoever has deploy
access to the Heroku app can do this step:

```
figaro heroku:set -e production -a name-of-heroku-app
```

*Important:* This step must be done anytime the contents of the secrets
file changes.

# Make sure Travis CI knows the secrets

Finally, the CI environment also needs to be able to generate
`config/application.yml` before 
running the tests. On Travis, you can add a step to the "before-script"
to do this:

```yaml
before_script:
  - gpg --passphrase "$KEY" --output config/application.yml \
       --decrypt config/application.yml.asc
```

Of course, this requires Travis to know the value of `$KEY`, so you must
also
go to your app's config variables in Travis and set the value
for `KEY` manually. 

If you add or modify secrets within application.yml, you'll need to
re-create and commit `config/application.yml.asc`, notify your
developers that they must merge the new file and manually re-create
`config/application.yml`, and re-run `figaro
heroku:set -e production` to populate the deploy with the new values.


