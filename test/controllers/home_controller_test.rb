require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get login" do
    get :login
    assert_response :success
  end

  test "should get logout" do
    get :logout
    assert_response :success
  end

  test "should get dashboard" do
    get :dashboard
    assert_response :success
  end

  test "should get messages" do
    get :messages
    assert_response :success
  end

  test "should get alerts" do
    get :alerts
    assert_response :success
  end

  test "should get tasks" do
    get :tasks
    assert_response :success
  end

end
