# frozen_string_literal: true

# Selenium Driver Code:
# https://github.com/SeleniumHQ/selenium/tree/trunk/rb/lib/selenium/webdriver

# Original Source
# https://gist.github.com/bbonamin/4b01be9ed5dd1bdaf909462ff4fdca95
require "capybara/rspec"
require "selenium/webdriver"
require "cucumber"


### Google Chrome
chrome_options = Selenium::WebDriver::Chrome::Options.new
chrome_options.add_preference(:download, prompt_for_download: false,
                                  default_directory: "/tmp/downloads")

chrome_options.add_preference(:browser, set_download_behavior: { behavior: "allow" })

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: chrome_options)
end

Capybara.register_driver :headless_chrome do |app|
  chrome_options.add_argument("--headless")
  chrome_options.add_argument("--disable-gpu")
  chrome_options.add_argument("--window-size=1440,900")

  driver = Capybara::Selenium::Driver.new(app, browser: :chrome, options: chrome_options)

  ### Allow file downloads in Google Chrome when headless!
  ### https://bugs.chromium.org/p/chromium/issues/detail?id=696481#c89
  bridge = driver.browser.send(:bridge)
  path = "/session/#{bridge.session_id}/chromium/send_command"
  bridge.http.call(:post, path, cmd: "Page.setDownloadBehavior",
                                params: {
                                  behavior: "allow",
                                  downloadPath: "/tmp/downloads"
                                })
  driver
end

#### Safari (macOS only.)
# To enable safaridriver:
# https://developer.apple.com/documentation/webkit/testing_with_webdriver_in_safari/
# Get the Tech Preview:
# # https://developer.apple.com/safari/resources/

Capybara.register_driver :safari do |app|
  Capybara::Selenium::Driver.new(app, browser: :safari)
end

Capybara.register_driver :stp do |app|
  # safari = Selenium::WebDriver::Safari
  # safari.technology_preview!
  Selenium::WebDriver::Safari.technology_preview!
  Capybara::Selenium::Driver.new(app, browser: :safari)
end

### Firefox
Capybara.register_driver :firefox do |app|
  Capybara::Selenium::Driver.new(app, browser: :firefox)
end

Capybara.register_driver :headless_firefox do |app|
  options = Selenium::WebDriver::Firefox::Options.new
  options.headless! # added on https://github.com/SeleniumHQ/selenium/pull/4762
  Capybara::Selenium::Driver.new(app, browser: :firefox, options:)
end

if ENV["DRIVER"].present?
  puts "FOUND DRIVER #{ENV['DRIVER'].parameterize.underscore.to_sym}"
  # be nice and accept 'Headless Chrome', spaces, etc.
  Capybara.default_driver = ENV["DRIVER"].parameterize.underscore.to_sym
elsif ENV["GUI"].present?
  Capybara.default_driver = :chrome
else
  Capybara.default_driver = :headless_chrome
end

puts "\nRUNNING CAPYBARA WITH DRIVER #{Capybara.javascript_driver}\n\n"
