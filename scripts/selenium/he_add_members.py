from selenium import webdriver
import pandas as pd
import time

### Initialize a web driver ###
options = webdriver.EdgeOptions()
driver = webdriver.Edge(options=options)

### Login to heroku ###
driver.get("https://id.heroku.com/login")

email_input = driver.find_element(by="name", value="email")
password_input = driver.find_element(by="name", value="password")

email_input.send_keys("your email")         # CHANGE this value
password_input.send_keys("your password")   # CHANGE this value

login_button = driver.find_element(by="name", value="commit")
login_button.click()

time.sleep(30) # Use this time to quickly login using 2-Factor Authentication

### Collect students' heroku emails ###
he_username_column_index = 5                # CHANGE this value
new_member_usernames = pd.read_csv('../email_surveys.csv').iloc[:, he_username_column_index]

### Perform clicks and form inputs needed to add each student ###
for member in new_member_usernames:
    driver.get('https://dashboard.heroku.com/teams/esaas/access')

    # the 'emberxxx' values here seem to change so it may be worth refreshing them
    inv_member_button = driver.find_element(by="xpath", value='//*[@id="ember38"]')  
    inv_member_button.click()
    time.sleep(1)
    new_member_email_input = driver.find_element(by="xpath", value='//*[@id="ember200"]')
    new_member_email_input.send_keys(member)
    time.sleep(1)
    confirm_invite_button = driver.find_element(by="xpath", value='//*[@id="ember213"]')
    confirm_invite_button.click()
    time.sleep(1)
    