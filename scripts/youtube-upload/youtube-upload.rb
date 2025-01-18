#!/usr/bin/env ruby

require 'selenium-webdriver'
require 'webdrivers/chromedriver'
require 'google_drive'

def main
  abort "Usage: #{ARGV[0]} youtube@email.com youtube_password" if ARGV.length < 3
  email,pass = ARGV[1], ARGV[2]
  driver = YoutubeSeleniumDriver.new(email,pass)
  driver.login
  driver.upload
end

class YoutubeSeleniumDriver
  def initialize(email, pass)
    @email = email
    @pass = pass
    # Set up the Selenium WebDriver
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--start-maximized')

    @driver = Selenium::WebDriver.for :chrome, options: options
    @wait = Selenium::WebDriver::Wait.new(timeout: 10)
  end

  def login
    # Navigate to YouTube
    driver.navigate.to 'https://www.youtube.com/'

    # Log in to YouTube
    driver.find_element(:xpath, '//tp-yt-paper-button[@aria-label="Sign in"]').click

    email_field = wait.until { driver.find_element(:id, 'identifierId').displayed? }
    email_field.send_keys(@email)
    email_field.send_keys(:enter)

    password_field = wait.until { driver.find_element(:name, 'password').displayed? }
    password_field.send_keys(@pass)
    password_field.send_keys(:enter)

    # If Two-Factor Authentication (2FA) is enabled, you might need to manually handle it
    # The following wait is just a placeholder, adapt as needed
    begin
      wait.until { driver.find_element(:id, 'avatar-btn').displayed? }
      puts 'Login successful!'
    rescue Selenium::WebDriver::Error::TimeOutError
      puts 'Manual intervention may be required for Two-Factor Authentication'
    end
  end
    
  def upload(title, desc)

    # Navigate to the upload page
    driver.navigate.to 'https://www.youtube.com/upload'

    # Upload the video file
    wait.until { driver.find_element(:xpath, '//input[@type="file"]').displayed? }
    upload_element = driver.find_element(:xpath, '//input[@type="file"]')
    upload_element.send_keys('/path/to/your/video.mp4')

    # Set the video title and description
    wait.until { driver.find_element(:xpath, '//ytcp-mention-input[@id="textbox"]').displayed? }
    title_element = driver.find_element(:xpath, '//ytcp-mention-input[@id="textbox"]')
    title_element.send_keys(title)

    description_element = driver.find_element(:xpath, '//ytcp-mention-input[@id="textbox"]')
    description_element.send_keys(desc)

    # Click the "Next" buttons (multiple times for different steps)
    3.times do
      wait.until { driver.find_element(:xpath, '//ytcp-button[@id="next-button"]').displayed? }
      driver.find_element(:xpath, '//ytcp-button[@id="next-button"]').click
    end

    # Publish the video (you may need to adjust this depending on your publishing settings)
    wait.until { driver.find_element(:xpath, '//ytcp-button[@id="done-button"]').displayed? }
    driver.find_element(:xpath, '//ytcp-button[@id="done-button"]').click

    # Close the browser
    driver.quit

  end
end

main()
