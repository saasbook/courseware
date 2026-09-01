When /^I visit the site for the first time$/ do
  visit '/'
end

Then /^I should see an empty board$/ do
  # 1 if debugger
  expect(page.text).to match /0\s+1\s+2\s+3\s+4\s+5\s+6\s+7\s+8/
end
