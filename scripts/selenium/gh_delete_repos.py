from selenium import webdriver
from selenium.common.exceptions import NoSuchElementException
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
time.sleep(1)

### Collect all the names of the repos you'd like to delete ####

# Specify what page of repos to start deleting from and to
start_page = 3                              # CHANGE this value
end_page = 24                               # CHANGE this value

# Specify how many repos are on the last page to stop the loop before an error
num_repos_last_page = 3                     # CHANGE this value
repo_names = []
end_repo = 30                               # Only CHANGE if the number of repos on a full page is no longer 30
try:
    for page in range(start_page, end_page + 1):
        driver.get('https://github.com/orgs/cs169/repositories?page=' + str(page))
        for repo in range(1, end_repo + 1):
            repo_names.append(driver.find_element(by="xpath", value='//*[@id="org-repositories"]/div/div/div[1]/ul/li[' + str(repo) + ']/div/div[1]/div[1]/h3/a').text)
except NoSuchElementException():
    pass

### Delete all the repos found in the previous loop ###
for repo in repo_names:
    driver.get('https://github.com/cs169/' + repo + '/settings')
    
    delete_repo_button = driver.find_element(by="xpath", value='//*[@id="options_bucket"]/div[9]/ul/li[4]/details/summary')
    delete_repo_button.click()

    repo_name_field = password_input = driver.find_element(by="xpath", value='//*[@id="options_bucket"]/div[9]/ul/li[4]/details/details-dialog/div[3]/form/p/input')
    repo_name_field.send_keys("cs169/" + repo)

    confirm_delete_button = driver.find_element(by="xpath", value='//*[@id="options_bucket"]/div[9]/ul/li[4]/details/details-dialog/div[3]/form/button')
    confirm_delete_button.click()


