require 'test_helper'

class CistacksControllerTest < ActionController::TestCase
  setup do
    @cistack = cistacks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cistacks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cistack" do
    assert_difference('Cistack.count') do
      post :create, cistack: { name: @cistack.name }
    end

    assert_redirected_to cistack_path(assigns(:cistack))
  end

  test "should show cistack" do
    get :show, id: @cistack
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cistack
    assert_response :success
  end

  test "should update cistack" do
    patch :update, id: @cistack, cistack: { name: @cistack.name }
    assert_redirected_to cistack_path(assigns(:cistack))
  end

  test "should destroy cistack" do
    assert_difference('Cistack.count', -1) do
      delete :destroy, id: @cistack
    end

    assert_redirected_to cistacks_path
  end
end
