# Bulk creation/deletion of many repos and cs169a-team

```text
Usage: ./github-repos.rb [required options] [invite|team_repos|remove|remove_access]

GITHUB_ORG_API_KEY for the org must be set as an environment variable.

'invite' invites students provided in .csv file and creates teams, 'team_repos' creates team repos, 'remove' remove students, repos, teams from the org

It's safe to run multiple times.

Required arguments:
    -c, --csv=CSVFILE                CSV file containing at least "Team" and "Email" named columns
    -o, --orgname=ORGNAME            The name of the org eg org_name
    -f, --filename=FILENAME          The base filename for repos, eg "fa23-actionmap-04", actionmap is the base file name of the repo
    -p, --prefix=PREFIX              Semester prefix, eg "fa23" create a repos prefix, "fa23-actionmap-04", etc.
    -t, --template=TEMPLATE          The repo template to use to generate individual or team repos (should be of format org/repo-name), eg saasbook/chips-3.5
    -s, --studentteam=STUDENTTEAM    The team name of all the students team
    -g, --gsiteam=GSITEAM            The team name of all the staff team
```

This script creates a team that include all students in the same semester, eg fa23.
Then creates different child teams for them for the chip10.5. At a minimum,
you need a CSV file listing all enrolled students with columns 'Email' and 'Team'.
You may optionally provide a column 'GitHub Username' to invite users with their
username instead of their email.
The values in the Team columns should be nonnegative integers identifying teams.

Org setting: Assume Base permissions is no permission, each students can only access their team repos.

## Usage

### Permissions

You must have the following permissions in the org:

- Repository administration - read and write
- Repository metadata - read
- Organization administration - read and write
- Organization members - read and write

### Access Token

You will need to configure a fine-grained personal access token **FOR YOURSELF**.
You can do this in `settings > Developer Settings > Personal access tokens > Fine-grained tokens`.
You will need to make one and change the resource owner from your account to your org.
It must have the above permissions (meaning you must as well).
After you have this value, you will need to export it in the environment you execute
the command from as `GITHUB_ORG_API_KEY`: `export GITHUB_ORG_API_KEY=<insert key here>`.

### Create a team under the org that includes all students in the same semester

**Use case:** Create a team called STUDENTTEAM, and send invitations
to the students in csv file. If STUDENTTEAM exists, delete the team and
create a new one. (Team repos still exist)
For all students NOT in that team, add/invite into that team.

### Create 10.5 repos for each child team

**Use case:** Each team (as identified by Team column in CSV file)
gets a repo for chip 10.5.  Repos' names are formed
by concatenating the prefix, base file name, and the team ID.
(eg "fa23-actionmap-04" for team #4) For all students on that team who do
NOT already have access to the repo, give them write access on the repo.
Add all repos to the gsiteam with admin permission.

### Remove all team members from students team, and delete all the repos

**Use case:** Delete all repos whose name matches the "PREFIX-FILENAME-team number".
Remove all students and subteams in STUDENTTEAM from the org.

### Remove student access to all the chip 10.5 repos

**Use case:** Only remove the access of students teams, repos still can be accessed by
gsi team.

## Exampls

```bash
export GITHUB_ORG_API_KEY=$(gh auth token)
# Create a team for all students in the same semester, for CHIPS 4.8
./github-repos.rb \
    team_repos \
    --csv=team.csv \
    --orgname=cs169 \
    --filename=fa25-chips-4.8 \
    --prefix=fa25 \
    --template=saasbook/hw-rails-intro \
    --studentteam=fa25-students \
    --gsiteam=fa25-gsis \
```
