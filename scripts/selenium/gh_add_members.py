from selenium import webdriver
import pandas as pd
import time

### Initialize a web driver ###
options = webdriver.EdgeOptions()
driver = webdriver.Edge(options=options)

### Login to github ###
driver.get("https://github.com/login")

email_input = driver.find_element(by="name", value="login")
password_input = driver.find_element(by="name", value="password")

email_input.send_keys("your email")         # CHANGE this value
password_input.send_keys("your password")   # CHANGE this value

login_button = driver.find_element(by="name", value="commit")
login_button.click()

gh_username_column_index = 4                # CHANGE this value
new_member_usernames = pd.read_csv('../email_surveys.csv').iloc[:, gh_username_column_index]

### Perform clicks and form inputs needed to add each student ###
for member in new_member_usernames: 
    driver.get('https://github.com/orgs/cs169/people')

    inv_member_button = driver.find_element(by="xpath", value="/html/body/div[1]/div[5]/main/div/div[2]/div/div[2]/div/div/div[1]/div/details[2]/summary")
    inv_member_button.click()
    time.sleep(1)
    new_member_username_input = driver.find_element(by="xpath", value='//*[@id="org-invite-complete-input"]')
    new_member_username_input.send_keys(member)
    time.sleep(1)
    select_member_button = driver.find_element(by="xpath", value='//*[@id="org-invite-complete-results-option-0"]/p[1]')
    select_member_button.click()
    time.sleep(0.5)
    inv_button = driver.find_element(by="xpath", value='/html/body/div[1]/div[5]/main/div/div[2]/div/div[2]/div/div/div[1]/div/details[2]/details-dialog/form/div/div/button')
    inv_button.click()
    time.sleep(0.5)
    reinstate = "back to UC Berkeley" in driver.find_element(by="xpath", value='/html/body/div[1]/div[5]/main/div/div[1]/h2').text
    if reinstate:
        reinstate_button = driver.find_element(by="xpath", value='//*[@id="reinstate-form"]/button')
        reinstate_button.click()
    else:
        send_inv_button = driver.find_element(by="xpath", value='/html/body/div[1]/div[5]/main/div[2]/form[2]/div[2]/div/button')
        send_inv_button.click()
    time.sleep(1)

    

