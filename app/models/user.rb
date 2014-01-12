class User < ActiveRecord::Base
  has_many :drills
  has_many :passages
  has_many :songs

  acts_as_authentic do |auth|
    auth.login_field = :email
  end

  def owns?(item)
    return false unless item.respond_to? :user

    return self.id.eql? item.user.id
  end
end
