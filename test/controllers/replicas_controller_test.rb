require 'test_helper'

class ReplicasControllerTest < ActionController::TestCase
  setup do
    @replica = replicas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:replicas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create replica" do
    assert_difference('Replica.count') do
      post :create, replica: { destination: @replica.destination, name: @replica.name }
    end

    assert_redirected_to replica_path(assigns(:replica))
  end

  test "should show replica" do
    get :show, id: @replica
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @replica
    assert_response :success
  end

  test "should update replica" do
    patch :update, id: @replica, replica: { destination: @replica.destination, name: @replica.name }
    assert_redirected_to replica_path(assigns(:replica))
  end

  test "should destroy replica" do
    assert_difference('Replica.count', -1) do
      delete :destroy, id: @replica
    end

    assert_redirected_to replicas_path
  end
end
