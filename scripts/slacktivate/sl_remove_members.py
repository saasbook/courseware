from slacktivate.slack.methods import user_deactivate
from slacktivate.macros.provision import users_list
import pandas as pd

### Create a list of all current (non-deactivated) members ###
curr_users = users_list()

### Collect current student emails from survey ###
sl_emails_column_index = 1
curr_students = list(pd.read_csv('email_surveys.csv').iloc[:, sl_emails_column_index])

### List instructors' emails and other members you'd like to keep that are not included above ###
other_users_to_keep = []

### Combine these groups to form an allowlist of members to avoid being deactivated ###
users_to_keep = curr_students + other_users_to_keep

### Deactivate all members not in the users_to_keep list ###
for user in curr_users:
    if user[0] not in users_to_keep:
        user_deactivate(user[1])
