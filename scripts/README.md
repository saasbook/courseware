# Useful scripts for managing ESaaS courses

# <center>__email_surveys.csv__</center>

Should contain each student's email for each service to which they need to be added (i.e. Github, Heroku, or Pivotal Tracker). Suggested columns provided but can be replaced. Each script that uses this file will need to be given which column number (0-indexed) is associated with emails for the given service.

# <center>__/slacktivate__</center>
For all slacktivate scripts:

&nbsp;&nbsp;&nbsp;1. Ensure that the workspace has at least a plus-level subscription. Many of the API calls made by slacktivate are only available to plus-level workspaces.

&nbsp;&nbsp;&nbsp;2. Paste your Slack API token in the specification.yml file. Follow [slacktivate's spec](https://github.com/jlumbroso/slacktivate#prerequisites-having-owner-access-and-getting-an-api-token) for help getting a valid API token.

&nbsp;&nbsp;&nbsp;3. Visit [this link](https://berkeley-cs169.slack.com/admin) and click the 'Export Member List' button. Download the file and have it replace the 'slack-berkeley-cs169-members.csv' file in the `/slacktivate/input` directory.

&nbsp;&nbsp;&nbsp;4. cd to the /slacktivate directory and run the command: `slacktivate --spec ./specification.yml repl` to launch the slacktivate's Python REPL.

&nbsp;&nbsp;&nbsp;5. Copy-paste the desired script into the REPL to run it.

### __sl_add_members.py__

Bulk-add members to a Slack workspace with at least a Plus-level subscription based on the contents of `\scripts\email_surveys.csv`. By Simon Jovanovic (@simonjov).

### __sl_remove_members.py__

Bulk-remove members from a Slack workspace with at least a Plus-level subscription. By Simon Jovanovic (@simonjov).

# <center> __/selenium__ </center>
The selenium web driver for each of the scripts is currently using Microsoft Edge. The browser used by selenium can be changed in the first few lines of each of the scripts. However, since there may be compatibility issues between different implementations of methods across web drivers, it is still suggested to download Microsoft Edge in order to run these scripts in the same environment in which they were developed.

Each script has certain values that either need to or can be changed for each use case. These are denoted by comments in this or a similar form: &nbsp; `# CHANGE this value`.

### __gh_add_members.py__

Bulk-add members to a GitHub or GitHub Classroom org based on the contents of `\scripts\email_surveys.csv`. By Simon Jovanovic (@simonjov).

### __gh_delete_repos.py__

Bulk-delete repositories from a GitHub or GitHub Classroom org. By Simon Jovanovic (@simonjov).

### __gh_remove_members.py__

Bulk-remove members from a GitHub or GitHub Classroom org. By Simon Jovanovic (@simonjov).

### __he_add_members.py__

Bulk-add members to a Heroku org based on the contents of `\scripts\email_surveys.csv`. 2-Factor Authentication is required for logging into heroku. The script provides 30 seconds for this step but more time can be added if necessary. By Simon Jovanovic (@simonjov).

### __he_remove_members.py (NOT WORKING, NEEDS IMPROVEMENT)__

Intended to bulk-remove members from a Heroku org. Currently not working due to difficulty in automation of removal. By Simon Jovanovic (@simonjov).

### __pt_add_members.py__

Bulk-add members to a Pivotal Tracker based on the contents of `\scripts\email_surveys.csv`. By Simon Jovanovic (@simonjov).


