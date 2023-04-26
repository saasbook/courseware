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

### Create allowlist of non admin users to avoid removing ###
non_admin_members_to_keep = []              # CHANGE this value

# TODO: figure out how each edit button is labelled as a function of its row
row = 1
edit_member_row = lambda row : 41 + 2*(row-1)

while True: 

    driver.get('https://dashboard.heroku.com/teams/esaas/access')
    time.sleep(5)
    # TODO: Process crashes due to a NoSuchElementFoundError on the 'ember elements'
    # it seems that the ember values change and make it hard to automate clicking each element
    member = driver.find_element(by="xpath", value='//*[@id="ember4"]/div[2]/div[2]/section/table/tbody/tr[' + str(row) + ']/td[1]/div/span').text
    not_admin = 'admin' != driver.find_element(by="xpath", value='//*[@id="ember4"]/div[2]/div[2]/section/table/tbody/tr[' + str(row) + ']/td[2]/div/span').text
    if not_admin and member not in non_admin_members_to_keep:
        edit_member_button = driver.find_element(by="xpath", value='//*[@id="ember' + str(edit_member_row(row)) + '"]')
        edit_member_button.click()
        time.sleep(1)
        remove_user_button = driver.find_element(by="xpath", value='//*[@id="ember609"]')
        remove_user_button.click()
        time.sleep(1)
        confirm_removal_button = driver.find_element(by="xpath", value='//*[@id="ember619"]')
        confirm_removal_button.click()
        time.sleep(0.5)
    else:
        row += 1
