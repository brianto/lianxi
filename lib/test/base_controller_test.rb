require 'test_helper'

module BaseControllerTest
  extend ActiveSupport::Testing::Declarative

  def model_name
    @controller.controller_name.classify
  end

  def model
    Kernel.const_get model_name
  end

  def fixture(name)
    send model_name.downcase.pluralize, name
  end

  test "can get show" do
    model = fixture(:empty)

    get :show, :id => model.id

    assert_response :success
  end

  [:new, :index].each do |method|
    test "can_get_#{method}" do
      get method
      assert_response :success
    end
  end
end
