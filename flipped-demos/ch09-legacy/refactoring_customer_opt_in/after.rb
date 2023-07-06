#  version 3

# in customer.rb

def has_opted_out_of_email?
  e_blacklist? && valid_email_address?
end

# in handler for Login action

flash[:notice] = login_message || "Logged in successfully"

# in ApplicationController

def encourage_opt_in_message
  m = Option.value(:encourage_email_opt_in)
  m << ' Click the Billing Address tab (above) to update your preferences.' unless m.blank?
  return m
end

def login_message
  encourage_opt_in_message if current_user.has_opted_out_of_email? 
end
