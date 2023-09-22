# Bulk creation/deletion of many repos and student teams

```
Usage: ./github-repos.rb [required options] [invite|create_teams|indiv_repos|group_repos|remove_indiv_repos|remove_group_repos|remove_teams|remove_group_repos_access] [optional options]

GITHUB_ORG_API_KEY for the org must be set as an environment variable.

It's safe to run multiple times.

'invite':
Create a team called STUDENTTEAM under the org and send invitations to students to the team.
If STUDENTTEAM already exists, the script will resend invitation to students.

If PREFIX is provided, it will assume the csv file contains "Group" column, and create groups(child teams) under 
the STUDENTTEAM, and invites them to groups.

Required options:
    -c, --csv=CSVFILE                CSV file containing at least "Username" named columns
    -s, --studentteam=STUDENTTEAM    The team name for students' team
    -o, --orgname=ORGNAME            The name of the org

Optional options:
    -p, --prefix=PREFIX              Semester prefix, eg fa23. If prefix is not provided, it will not create groups.

'create_groups'
Assuming students are in STUDENTTEAM, create groups for students for CHIP 10.5 and add them to corresponding groups.

Required options:
    -c, --csv=CSVFILE                CSV file containing at least "Group" and "Username" named columns
    -s, --studentteam=STUDENTTEAM    The team name for students' team
    -p, --prefix=PREFIX              Semester prefix, eg fa23.
    -o, --orgname=ORGNAME            The name of the org

'indiv_repos'
Create CHIPS repos for each student in STUDENTTEAM. Repos' names are form like "[PREFIX]-[username]-[ASSIGNMENT]"
[username] stands for the GitHub username.

Required options:
    -o, --orgname=ORGNAME            The name of the org
    -s, --studentteam=STUDENTTEAM    The team name for students' team
    -p, --prefix=PREFIX              Semester prefix, eg fa23.
    -t, --template=TEMPLATE          The repo name within the org to use as template
    -g, --gsiteam=GSITEAM            The team name of staff team
    -a, --assignment=ASSIGNMENT      The assignment name

'group_repos'
Create repos for each group. Repos' names are form like "[PREFIX]-[ASSIGNMENT]-[GROUPNUM]"
Make sure groups are formed before running this command.

Required options:
    -o, --orgname=ORGNAME            The name of the org
    -p, --prefix=PREFIX              Semester prefix, eg fa23.
    -t, --template=TEMPLATE          The repo name within the org to use as template
    -a, --assignment=ASSIGNMENT      The assignment name. eg chip-10.5
    -s, --studentteam=STUDENTTEAM    The team name for students' team
    -g, --gsiteam=GSITEAM            The team name of staff team

'remove_indiv_repos'
Delete all repos whose names are formed like "[PREFIX]-[username]-[ASSIGNMENT]".

Required options:
    -o, --orgname=ORGNAME            The name of the org
    -p, --prefix=PREFIX              Semester prefix, eg fa23.
    -a, --assignment=ASSIGNMENT      The assignment name. eg chip-10.5

'remove_group_repos'
Delete all repos whose names are formed like "[PREFIX]-[ASSIGNMENT]-[GROUPNUM]".

Required options:
    -o, --orgname=ORGNAME            The name of the org
    -p, --prefix=PREFIX              Semester prefix, eg fa23.
    -a, --assignment=ASSIGNMENT      The assignment name. eg chip-10.5

'remove_teams'
Remove all students and groups in STUDENTTEAM from the org.
Remove STUDENTTEAM as well.

Required options:
    -o, --orgname=ORGNAME            The name of the org
    -p, --prefix=PREFIX              Semester prefix, eg fa23.
    -s, --studentteam=STUDENTTEAM    The team name for students' team

'remove_group_repos_access'
Remove group access to group repos that are formed like "[PREFIX]-[ASSIGNMENT]-[GROUPNUM]".

Required options:
    -o, --orgname=ORGNAME            The name of the org
    -p, --prefix=PREFIX              Semester prefix, eg fa23.
    -a, --assignment=ASSIGNMENT      The assignment name. eg chip-10.5 
```

This script offer commands to manage student teams and groups, repositories.

Org setting: Assume Base permissions is no permission, each students can only access their team repos.

**Assumption:** You have a GITHUB ORG API key.

### Create a student team under the org and send invitations to students

**Use case:** Create a team called STUDENTTEAM if it don't exist, and send invitations 
to the students in csv file. For students NOT in STUDENTTEAM, invite them to STUDENTTEAM.

### Create groups for students for CHIP 10.5

**Use case:** Create groups for students for CHIP 10.5. 

### Create CHIPS repo for each student

**Use case:** Create CHIP repos for each student in STUDENTTEAM.
The repos' names are formed like  "[PREFIX]-[username]-[ASSIGNMENT]". There will 
be only one collabrator. Give GSITEAM admin access to the created repos.

### Create 10.5 repos for each group

**Use case:** Each group (as identified by "Group" column in CSV file)
gets a repo for chip 10.5.  Repos' names are formed like "[PREFIX]-[ASSIGNMENT]-[TEAMNUM]"
Every one in the same group has write access to the repo.
Give GSITEAM admin access to the created repos.

### Remove the CHIPS repos

**Use case:** Delete all repos whose names are formed like "[PREFIX]-[username]-[ASSIGNMENT]".

### Remove CHIP 10.5 repos

**Use case:** Delete all repos whose names are formed like "[PREFIX]-[ASSIGNMENT]-[GROUPNUM]".

### Remove all team members from students teams, then delete all teams

**Use case:** Remove all students and groups in STUDENTTEAM from the org.

### Remove student access to all the chip 10.5 repos 

**Use case:** Only remove the access of students groups, repos can still be accessed by
gsi team.

