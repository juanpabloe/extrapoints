require 'test_helper'

class StudentsControllerTest < ActionController::TestCase
  test "should get teachers" do
    get :teachers
    assert_response :success
  end

end
