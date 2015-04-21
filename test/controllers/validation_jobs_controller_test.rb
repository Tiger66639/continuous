require 'test_helper'

class ValidationJobsControllerTest < ActionController::TestCase
  setup do
    @validation_job = validation_jobs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:validation_jobs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create validation_job" do
    assert_difference('ValidationJob.count') do
      post :create, validation_job: { definition: @validation_job.definition, description: @validation_job.description, name: @validation_job.name }
    end

    assert_redirected_to validation_job_path(assigns(:validation_job))
  end

  test "should show validation_job" do
    get :show, id: @validation_job
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @validation_job
    assert_response :success
  end

  test "should update validation_job" do
    patch :update, id: @validation_job, validation_job: { definition: @validation_job.definition, description: @validation_job.description, name: @validation_job.name }
    assert_redirected_to validation_job_path(assigns(:validation_job))
  end

  test "should destroy validation_job" do
    assert_difference('ValidationJob.count', -1) do
      delete :destroy, id: @validation_job
    end

    assert_redirected_to validation_jobs_path
  end
end
