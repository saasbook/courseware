import pandas as pd
import traceback
from slacktivate.slack.methods import user_create
from slack_scim import SCIMApiError

### Collect current student emails from survey to avoid ###
sl_emails_column_index = 1
curr_students = list(pd.read_csv('../email_surveys.csv').iloc[:, sl_emails_column_index])

### Create new slack users with the above emails, making usernames from the text before the @ sign ###
for student_email in curr_students:
    try:
        user_create({"email": student_email, "userName": student_email.split('@')[0]})
    except SCIMApiError:
        traceback.print_exc()