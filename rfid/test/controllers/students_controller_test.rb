require 'test_helper'

class StudentsControllerTest < ActionController::TestCase
  setup do
    @student = students(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:students)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create student" do
    assert_difference('Student.count') do
      post :create, student: { card_rfid: @student.card_rfid, contact_number: @student.contact_number, course: @student.course, first_name: @student.first_name, id_number: @student.id_number, last_name: @student.last_name, middle_name: @student.middle_name, year_level: @student.year_level }
    end

    assert_redirected_to student_path(assigns(:student))
  end

  test "should show student" do
    get :show, id: @student
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @student
    assert_response :success
  end

  test "should update student" do
    patch :update, id: @student, student: { card_rfid: @student.card_rfid, contact_number: @student.contact_number, course: @student.course, first_name: @student.first_name, id_number: @student.id_number, last_name: @student.last_name, middle_name: @student.middle_name, year_level: @student.year_level }
    assert_redirected_to student_path(assigns(:student))
  end

  test "should destroy student" do
    assert_difference('Student.count', -1) do
      delete :destroy, id: @student
    end

    assert_redirected_to students_path
  end
end