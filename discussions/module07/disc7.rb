Given /^my birthday is set to "(.*")"/ do |date|
  @customer.update_attributes!(:birthday => Date.parse(date))
end

Given /^I am logged in as user "(.*)"$/ do |username|
  login_as!(username)
  @current_user = User.find_by_name!(username)
end

Given /^my cart contains the item "(.*)"$/ do |item|
  @cart = @current_user.cart
end

Then /^I should see the following: (.*)$/ do |list|
  movies = list.split(/⁎,⁎/)
  movies.each do |movie|
    steps %Q{Then I should see "#{movie}"}
  end
end

Then /^I should see the following: (.⁎)$/ do |list|
  movies = list.split(/\s⁎,\s⁎/)
  movies.each do |movie|
    steps %Q{Then I should see "#{movie}" within "#search_results"}
  end
end

Then /^I should (not)?see the following: (.⁎)$/ do |neg, list|
  movies = list.split(/\s⁎,\s⁎/)
  movies.each do |movie|
    step %Q{Then I should #{neg}see "#{movie}" within"#search_results"}
  end
end
