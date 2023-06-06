# Bulk creation/deletion of many repos and cs169a-team

```
Usage: ./github-repos.rb [required options] [invite|repos|remove]

GITHUB_ORG_API_KEY for the org must be set as an environment variable.

'invite' invites students provided in .csv file and creates teams, 'repos' creates team repos, 'remove' remove students, repos, teams from the org

It's safe to run multiple times.

Required arguments:
    -c, --csv=CSVFILE                CSV file containing at least "Team" and "Username" named columns
    -o, --orgname=ORGNAME            The name of the org eg org_name
    -f, --filename=FILENAME          The base filename for repos  
    -p, --prefix=PREFIX              Semester prefix, eg "fa23" create a repos prefix, "fa23-actionmap-04", etc.
    -t, --template=TEMPLATE          The repo name within the org to use as template eg repo_name (Assume the repo own by org) 
```

This script creates a team that include all stundents in the same semester, eg fa23. 
Then creates different child teams for them for the chip10.5. At a minimum, 
you need a CSV file listing all enrolled students with columns 'Email' and 'Team'.  
The values in the Team columns should be nonnegative integers identifying teams.

Org setting: Assume Base permissions is no permission, each students can only access their team repos.

**Assumption:** You have a GITHUB ORG API key.

### Create a team under the org that includes all students in the same semester

**Use case:** Create a team "cs169a-students", and send invitations 
to the students in csv file. If the team exists, delete the team and 
create a new one. For all students NOT in that team, add/invite into 
that team.

### Create 10.5 repos for each child team 

**Use case:** Each team (as identified by Team column in CSV file)
gets a repo for chip 10.5.  Repos' names are formed
by concatenating the prefix, base file name, and the team ID. 
(eg "fa23-actionmap-04" for team #4) For all students on that team who do 
NOT already have access to the repo, give them write access on the repo.

### Remove all team members from cs169a-student team, and delete all the repos

**Use case:** Delete all repos whose name matches the "base repo" name.
Remove all students in team "cs169a-students" from the org and team.

