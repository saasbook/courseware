# NOTE: This file does not compile, if you'd like it to run,
# you will need to create a Gemfile with the ActiveRecord gem specified

class User < ActiveRecord::Base
  validates :username, :presence => true
  validate :username_format

  def username_format
    if username.length < 10 or not username =~ /^[a-z]/i
      errors.add(:username, "is not formatted correctly")
    end
  end
end

class AdminController < ApplicationController
  before_filter :check_admin
  def check_admin
    if not @user.admin
      flash[:notice] = "You must be an admin"
      redirect_to ’/admin_login’
    end
  end
end
