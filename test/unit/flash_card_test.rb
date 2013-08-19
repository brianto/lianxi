require 'test_helper'

class FlashCardTest < ActiveSupport::TestCase
  test "flash card user (owner)" do
    u = User.create :username => "user", :email => "user@user.com",
      :password => "user", :password_confirmation => "user"

    d = Drill.create :title => "drill", :description => "drill", :user => u

    fc = FlashCard.create :simplified => "s", :traditional => "t", :pinyin => "p", :jyutping => "j",
      :meaning => "m", :part_of_speech => "p", :teachable => d

    assert_equal u, fc.user
  end
end
