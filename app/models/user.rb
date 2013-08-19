class User < ActiveRecord::Base
  has_many :drills
    attr_accessible :drills_attributes
    accepts_nested_attributes_for :drills

  has_many :passages
    attr_accessible :passages_attributes
    accepts_nested_attributes_for :passages

  has_many :songs
    attr_accessible :songs_attributes
    accepts_nested_attributes_for :songs

  attr_accessible :username, :email, :password, :password_confirmation

  acts_as_authentic do |auth|
    auth.login_field = :email
  end

  def owns?(item)
    return false unless item.respond_to? :user

    return self.id.eql? item.user.id
  end
end
