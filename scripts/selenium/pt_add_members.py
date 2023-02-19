from selenium import webdriver
from selenium.common.exceptions import NoSuchElementException
import pandas as pd
import time

### Initialize a web driver ###
options = webdriver.EdgeOptions()
driver = webdriver.Edge(options=options)

### Login to github ###
driver.get("https://www.pivotaltracker.com/signin")

email_input = driver.find_element(by="name", value='credentials[username]')
email_input.send_keys("your email")         # CHANGE this value
next_button = driver.find_element(by="name", value='action')
next_button.click()
time.sleep(1)

password_input = driver.find_element(by="name", value="credentials[password]")
password_input.send_keys("your password")   # CHANGE this value
login_button = driver.find_element(by="name", value='action')
login_button.click()
time.sleep(1)

### Collect students' pivotal tracker emails ###
pt_emails_column_index = 6                  # CHANGE this value
new_member_usernames = pd.read_csv('../email_surveys.csv').iloc[:, pt_emails_column_index]

### Perform clicks and form inputs needed to add each student ###
for member in new_member_usernames: 
    driver.get('https://www.pivotaltracker.com/accounts/233155/memberships')

    new_member_button = driver.find_element(by="xpath", value='//*[@id="new_member_button"]')
    new_member_button.click()
    time.sleep(1)
    new_member_email_input = driver.find_element(by="xpath", value='//*[@id="members_for_lookup"]')
    new_member_email_input.send_keys(member)
    time.sleep(1)
    add_member_button = driver.find_element(by="xpath", value='//*[@id="add_member_button"]')
    add_member_button.click()
    time.sleep(1)

    # 'try: except:' needed for the addition of a member who has not yet created a pivotal tracker account 
    # due to an extra pop up needing to be addressed
    try:
        is_new_member = "NEW MEMBER" in driver.find_element(by="xpath", value='//*[@id="add_member_overlay"]/div[2]/div[1]/div/h3').text
        if is_new_member:
            # TODO: add support for filling in the name field (if not already filled) using the email survey data
            confirm_add_button = driver.find_element(by="xpath", value='//*[@id="new_add_member_button"]')
            confirm_add_button.click()
    except NoSuchElementException:
        continue
    time.sleep(1)

    

