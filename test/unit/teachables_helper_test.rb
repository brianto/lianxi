require 'test_helper'

class TeachablesHelperTest < ActionView::TestCase
  test "teachable paths" do
    @model_class = Drill
    drill = Drill.create

    assert_match(/\/drills\/(\d+)\/grid/,
                 grid_teachable_path(drill))
  end
end
