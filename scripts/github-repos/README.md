# Bulk creation/deletion of many repos and cs169a-team

```
Usage: ./github-repos.rb [required options] [invite|create_teams|indiv_repos|team_repos|remove_indivi_repos|remove_team_repos|remove_teams|remove_team_repo_access]

GITHUB_ORG_API_KEY for the org must be set as an environment variable.

It's safe to run multiple times.

'invite':
Create a team called STUDENTTEAM under the org that has all students in the same semester and send invitation

Required arguments:
    -c, --csv=CSVFILE                CSV file containing at leaset "Email"/"Username" named columns
    -s, --studentteam=STUDENTTEAM    The team name of all the students team

'create_teams'
Create child teams for students for CHIP 10.5

Required arguments:
    -c, --csv=CSVFILE                CSV file containing at least "Team" and "Email"/"Username" named columns
    -s, --studentteam=STUDENTTEAM    The team name of all the students team
    -p, --prefix=PREFIX              Semester prefix, eg fa23.

'indiv_repos'
Create CHIPS repo for each stedent in STUDENTTEAM. Repos' names are form like "PREFIX-[username]-FILENAME"

Required arguments:
    -s, --studentteam=STUDENTTEAM    The team name of all the students team
    -p, --prefix=PREFIX              Semester prefix, eg fa23.
    -t, --template=TEMPLATE          The repo name within the org to use as template
    -g, --gsiteam=GSITEAM            The team name of all the staff team
    -f, --filename=FILENAME          The base filename for repos

'team_repos'
Create 10.5 repos for each child team. Repos' names are form like "PREFIX-FILENAME-[Team number]"
Make sure child teams are formed before running this method.

Required arguments:
    -p, --prefix=PREFIX              Semester prefix, eg fa23.
    -t, --template=TEMPLATE          The repo name within the org to use as template
    -f, --filename=FILENAME          The base filename for repos.
    -s, --studentteam=STUDENTTEAM    The team name of all the students team
    -g, --gsiteam=GSITEAM            The team name of all the staff team

'remove_indiv_repos'
Delete all repos whose names are formed like "PREFIX-[username]-FILENAME".

Required arguments:
    -p, --prefix=PREFIX              Semester prefix, eg fa23.
    -f, --filename=FILENAME          The base filename for repos.

'remove_team_repos'
Delete all repos whose names are formed like "PREFIX-FILENAME-[Team number]".

Required arguments:
    -p, --prefix=PREFIX              Semester prefix, eg fa23.
    -f, --filename=FILENAME          The base filename for repos.

'remove_teams'
Remove all students and child teams in STUDENTTEAM from the org.
Remove STUDENTTEAM as well.

Required arguments:
    -p, --prefix=PREFIX              Semester prefix, eg fa23.
    -s, --studentteam=STUDENTTEAM    The team name of all the students team

'remove_team_repo_access'
Remove students access to CHIP 10.5 repos that are formed like "PREFIX-FILENAME-[Team number]".

Required arguments:
    -p, --prefix=PREFIX              Semester prefix, eg fa23.
    -f, --filename=FILENAME          The base filename for repos.
```

This script creates a team that include all stundents in the same semester, eg fa23. 
Then creates different child teams for them for the chip10.5. At a minimum, 
you need a CSV file listing all enrolled students with columns 'Email' and 'Team'.  
The values in the Team columns should be nonnegative integers identifying teams.

Org setting: Assume Base permissions is no permission, each students can only access their team repos.

**Assumption:** You have a GITHUB ORG API key.

### Create a team under the org that has all students in the same semester and send invitation

**Use case:** Create a team called STUDENTTEAM, and send invitations 
to the students in csv file. If STUDENTTEAM exists, delete STUDENTTEAM and 
create a new one. (Team repos still exist)
For all students NOT in STUDENTTEAM, add/invite into STUDENTTEAM.
Team column is not needed for this.

### Create child teams for students for CHIP 10.5

**Use case:** Create child teams for students for CHIP 10.5. 

### Create CHIPS repo for each stedent

**Use case:** Create CHIP repos for each student in STUDENTTEAM.
The repos' names are formed like  "fa23-[username]-FILENAME". There will 
be only one collabrator. Add all repos to the gsiteam with admin permission.

### Create 10.5 repos for each child team 

**Use case:** Each team (as identified by Team column in CSV file)
gets a repo for chip 10.5.  Repos' names are formed like "PREFIX-FILENAME-TEAMNUM"
Every one in the child team has write access to the repo.
Add all repos to the gsiteam with admin permission.

### Remove the CHIPS repos

**Use case:** Delete all repos whose names are formed like "PREFIX-[username]-FILENAME".

### Remove CHIP 10.5 repos

**Use case:** Delete all repos whose names are formed like "PREFIX-FILENAME-[Team number]".

### Remove all team members from students teams, then delete all teams

**Use case:** Remove all students and subteams in STUDENTTEAM from the org.

### Remove student access to all the chip 10.5 repos 

**Use case:** Only remove the access of students teams, repos still can be accessed by
gsi team.

