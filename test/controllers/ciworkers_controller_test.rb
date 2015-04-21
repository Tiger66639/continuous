require 'test_helper'

class CiworkersControllerTest < ActionController::TestCase
  setup do
    @ciworker = ciworkers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ciworkers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ciworker" do
    assert_difference('Ciworker.count') do
      post :create, ciworker: { flavor: @ciworker.flavor, image: @ciworker.image, name: @ciworker.name }
    end

    assert_redirected_to ciworker_path(assigns(:ciworker))
  end

  test "should show ciworker" do
    get :show, id: @ciworker
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ciworker
    assert_response :success
  end

  test "should update ciworker" do
    patch :update, id: @ciworker, ciworker: { flavor: @ciworker.flavor, image: @ciworker.image, name: @ciworker.name }
    assert_redirected_to ciworker_path(assigns(:ciworker))
  end

  test "should destroy ciworker" do
    assert_difference('Ciworker.count', -1) do
      delete :destroy, id: @ciworker
    end

    assert_redirected_to ciworkers_path
  end
end
