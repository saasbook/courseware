Given /student "(.*) (.*)" exists/ do |first,last|
  Student.create!(:first_name => first, :last_name => last, :sid_number => 999+rand(1000))
end

When /I visit the list of all students/ do
  visit students_path
end

Then /"(.*) (.*)" should appear before "(.*) (.*)"/ do |first1,last1, first2,last2|
  regex = /#{first1}.*#{last1}.*#{first2}.*#{last2}/m
  expect(page.text).to match(regex)
end
