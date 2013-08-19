require 'test_helper'

class DrillsControllerTest < ActionController::TestCase
  test "can get new" do
    get :new
    assert_response :success
  end

  test "create with no data gives error" do
    post :create, :drill => { }
    assert_template :new
  end

  test "create with full data goes to show" do
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
