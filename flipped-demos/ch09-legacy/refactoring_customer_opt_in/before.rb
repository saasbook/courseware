# version 1

# in CustomersController

def show
  if current_user.e_blacklist?  &&
      current_user.valid_email_address?  &&
      !(m = Option.value(:encourage_email_opt_in)).blank?
    m << ' Click the Billing Address tab (above) to update your preferences.'
    flash[:notice] ||= m
  end
end
