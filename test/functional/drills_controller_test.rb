require 'test_helper'
require 'test/base_controller_test'

class DrillsControllerTest < ActionController::TestCase
  # include BaseControllerTest

  test "create with no data gives error" do
    skip "refactor"
    post :create, :drill => { }
    assert_template :new
  end

  test "create with full data goes to show" do
    skip "refactor"
    u = User.create :username => "user", :email => "user@user.com",
      :password => "user", :password_confirmation => "user"

    post :create, :drill => {
      :title => "title",
      :description => "description",
      :user_id => u.id
    }

    assert_redirected_to drill_path(assigns(:drill))
  end
end
