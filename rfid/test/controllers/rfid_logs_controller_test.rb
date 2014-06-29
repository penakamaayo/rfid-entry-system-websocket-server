require 'test_helper'

class RfidLogsControllerTest < ActionController::TestCase
  setup do
    @rfid_log = rfid_logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rfid_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rfid_log" do
    assert_difference('RfidLog.count') do
      post :create, rfid_log: { card_rfid: @rfid_log.card_rfid, time: @rfid_log.time }
    end

    assert_redirected_to rfid_log_path(assigns(:rfid_log))
  end

  test "should show rfid_log" do
    get :show, id: @rfid_log
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rfid_log
    assert_response :success
  end

  test "should update rfid_log" do
    patch :update, id: @rfid_log, rfid_log: { card_rfid: @rfid_log.card_rfid, time: @rfid_log.time }
    assert_redirected_to rfid_log_path(assigns(:rfid_log))
  end

  test "should destroy rfid_log" do
    assert_difference('RfidLog.count', -1) do
      delete :destroy, id: @rfid_log
    end

    assert_redirected_to rfid_logs_path
  end
end
