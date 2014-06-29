require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  test "should get students_in" do
    get :students_in
    assert_response :success
  end

  test "should get students_out" do
    get :students_out
    assert_response :success
  end

end
