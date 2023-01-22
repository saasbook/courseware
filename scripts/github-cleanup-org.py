from selenium import webdriver
import time

# Initialize a web driver
options = webdriver.EdgeOptions()
driver = webdriver.Edge(options=options)

# Login to github
driver.get("https://github.com/login")

email_input = driver.find_element(by="name", value="login")
password_input = driver.find_element(by="name", value="password")

email_input.send_keys("your email")
password_input.send_keys("your password")

login_button = driver.find_element(by="name", value="commit")
login_button.click()

# Remove all outside collaborators (for other groups, replace the link at the top of the loop and the button xpaths accordingly)
while True: # May seem silly but the script will end once there aren't any members to delete anyway

    # Go to correct list of users (those that you'd like to remove)
    driver.get('https://github.com/orgs/cs169/outside-collaborators')

    # Remove all members on the current page (time.sleep necessary for dropdown and pop ups to load properly)
    select_all_checkbox = driver.find_element(by="id", value="select-all-checkbox")
    select_all_checkbox.click()
    time.sleep(1)
    dropdown_button = driver.find_element(by="xpath", value='/html/body/div[1]/div[5]/main/div/div[2]/div/div[2]/div/div/div[2]/div[1]/div[2]/details/summary')
    dropdown_button.click()
    time.sleep(1)
    remove_button = driver.find_element(by="xpath", value='/html/body/div[1]/div[5]/main/div/div[2]/div/div[2]/div/div/div[2]/div[1]/div[2]/details/details-menu/details/summary')
    remove_button.click()
    time.sleep(0.5)
    confirm_button = driver.find_element(by="xpath", value='/html/body/div[1]/div[5]/main/div/div[2]/div/div[2]/div/div/div[2]/div[1]/div[2]/details/details-menu/details/details-dialog/div[3]/form/button')
    confirm_button.click()
    time.sleep(0.5)

