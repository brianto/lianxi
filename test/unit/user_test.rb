require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "owns?" do
    king = User.create :username => "king", :email => "king@kingdom.com",
      :password => "iamgod", :password_confirmation => "iamgod"

    peasant = User.create :username => "peasant", :email => "peasant@kingdom.com",
      :password => "spareadime?", :password_confirmation => "spareadime?"

    passage = Passage.create :title => "passage", :user => king

    assert king.owns? passage
    refute peasant.owns? passage
  end
end
