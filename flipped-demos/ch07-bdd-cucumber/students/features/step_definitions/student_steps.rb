Given /^student "(.*) (.*)" exists$/ do |first,last|
  Student.create!(:first_name => first, :last_name => last)
end

When /^I visit the list of all students$/ do
  visit students_path
end

Then /^"(.*) (.*)" should appear before "(.*) (.*)"$/ do |first1,last1, first2,last2|
  byebug
  regex = /#{last1}.*#{first1}.*#{last2}.*#{first2}/
  expect(page.text).to match(regex)
end
