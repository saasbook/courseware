When /^I visit the site for the first time$/ do
  visit '/'
end

Then /^I should see an empty board$/ do
  # 1 if debugger
  expect(page.text).to match /0 1 2 3 4 5 6 7 8/
end
