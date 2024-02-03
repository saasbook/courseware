# Bulk creation/deletion of many Heroku apps and teams

```
Usage: ./heroku-apps.rb [required options] [individual|team|delapps|delusers]

HEROKU_API_KEY must be set as an environment variable.

'individual' creates individual apps, 'team' creates team apps, 'delapps' deletes any apps with given prefix,
'delusers' deletes all users in CSV file from the team. 

It's safe to run multiple times, since existing apps/collaborators are left alone.

Required arguments:
    -c, --csv=CSVFILE                CSV file containing at least "Team" and "Email" named columns
    -t, --team=TEAM                  Heroku team name that should own the apps
    -p, --prefix=PREFIX              App name prefix, eg "fa23" gives apps "fa23-01", "fa23-02", etc.
Optional arguments:
    -xEMAILS--extra-users=EMAILS     Comma-separated list of emails that should also be collaborators on apps
```

This script solves various problems related to the absence of the Heroku
free tier.  At a minimum, you need a CSV file listing all enrolled
students with columns 'Email' and 'Team'.  If you don't care about
team projects/team apps, the values in the Team column are irrelevant
but the column must be present.  If you do care about teams, the
values in the Team columns should be nonnegative integers identifying teams.

**Assumption:** You have a Heroku "instructor account" and have
created a Heroku Team to manage the apps in your course.

**Assumption:** You have a Heroku API key.

### Create individual student app containers within your Heroku team

**Use case:** Each student gets one Heroku app container to reuse for each CHIPS
during the course.  That student is the only collaborator on the app
(so other students cannot pull their source code from the Heroku
remote).  The apps are named by prepending the prefix you supply to a
sanitized (all nonalphanumeric characters replaced with hyphens) email
username.  So, for example, app prefix `fa23-` (you must include the
hyphen) and student emails `john+q.public@berkeley.edu` and
`jane_adams@berkeley.edu` will create app containers
`fa23-john-q-public` and `fa23-jane-adams`.

In addition, you may want to give access to other users, such as
course staff.  The `--extra-users` option lets you specify a list of
comma-separated email addresses of accounts that will also have access
to the apps.

It appears not to be necessary for there to exist Heroku accounts
corresponding to the email addresses; when those accounts get created,
they will have access to the apps.

### Create team app containers within your Heroku team

**Use case:** Each team (as identified by Team column in CSV file)
gets an app container on which to collaborate.  App names are formed
by concatenating the prefix with the team ID.  If the team ID is
numeric, it will be zero-padded to two digits, so you will get app
names like `fa23-00`, `fa23-01`, etc.; if not, it will be concatenated
verbatim to the prefix.

As with creating individual apps, you can specify extra users who
should have access.

### Delete all apps associated with the semester

Deletes all apps beginning with the common app prefix.

### Remove all team members from team

Remove from the Heroku team all team members whose emails appear in
the CSV file.  (This allows for leaving team members who are course
staff, e.g.)

## Running with Docker

Instead of switching to the right Ruby version manually, you can also build and use a Docker image to run this script.

### To build

To create the Docker image, clone this repository, cd into the script directory, and run:

```
docker build -t saasbook-script-heroku-apps .
```

### To run

Run the following, replacing the appropriate parameters.

If using Windows, you may need to change the `` `pwd` `` mount. Files in the working directory will be available to the container at `/app/files`, e.g. `-c /app/files/team-info.csv`.

```
docker run \
  -it \
  -v `pwd`:/app/files \
  -e HEROKU_API_KEY=[your_key] \
  saasbook-script-heroku-apps \
  [args] \
  [command]
```
