require 'test_helper'

class ExampleTest < ActiveSupport::TestCase
  test "example user (owner)" do
    u = User.create :username => "user", :email => "user@user.com",
      :password => "user", :password_confirmation => "user"

    d = Drill.create :title => "drill", :description => "drill", :user => u

    fc = FlashCard.create :simplified => "s", :traditional => "t", :pinyin => "p", :jyutping => "j",
      :meaning => "m", :part_of_speech => "p", :teachable => d

    e = Example.create :simplified => "s", :traditional => "t", :pinyin => "p", :jyutping => "j",
      :translation => "t", :flash_card => fc

    assert_equal u, e.user
  end
end
