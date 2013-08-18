class User < ActiveRecord::Base
  acts_as_authentic do |auth|
    auth.login_field = :email
  end

  attr_accessible :username, :email, :password, :password_confirmation
end
