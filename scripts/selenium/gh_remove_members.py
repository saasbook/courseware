from selenium import webdriver
import time

### Initialize a web driver ###
options = webdriver.EdgeOptions()
driver = webdriver.Edge(options=options)

### Login to github ###
driver.get("https://github.com/login")

email_input = driver.find_element(by="name", value="login")
password_input = driver.find_element(by="name", value="password")

email_input.send_keys("your email")                                     # CHANGE this value
password_input.send_keys("your password")                               # CHANGE this value

login_button = driver.find_element(by="name", value="commit")
login_button.click()

### Specify which group you will be mass removing from by CHANGING the link on line 25 ###
while True:

    # Go to correct list of users (those that you'd like to remove)
    driver.get('https://github.com/orgs/cs169/outside-collaborators')   # CHANGE this value

    # Remove all members on the current page (time.sleep necessary for dropdown and pop ups to load properly)
    select_all_checkbox = driver.find_element(by="id", value="select-all-checkbox")
    select_all_checkbox.click()
    time.sleep(1)
                                                                        # CHANGE below XPath value
    dropdown_button = driver.find_element(by="xpath", value='/html/body/div[1]/div[5]/main/div/div[2]/div/div[2]/div/div/div[2]/div[1]/div[2]/details/summary')
    dropdown_button.click()
    time.sleep(1)
                                                                        # CHANGE below XPath value
    remove_button = driver.find_element(by="xpath", value='/html/body/div[1]/div[5]/main/div/div[2]/div/div[2]/div/div/div[2]/div[1]/div[2]/details/details-menu/details/summary')
    remove_button.click()
    time.sleep(0.5)
                                                                        # CHANGE below XPath value
    confirm_button = driver.find_element(by="xpath", value='/html/body/div[1]/div[5]/main/div/div[2]/div/div[2]/div/div/div[2]/div[1]/div[2]/details/details-menu/details/details-dialog/div[3]/form/button')
    confirm_button.click()
    time.sleep(0.5)

