require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @current_user ||= FactoryGirl.create(:user)
  end

  test 'user needs to authenticate' do
    get :index, format: :json
    assert_response :unauthorized
  end

  test 'authenticated user get the list of task' do
    get :index, format: :json, auth_token: @current_user.authentication_token
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test 'get #index should track user' do
    time = @current_user.updated_at
    count = @current_user.sign_in_count

    get :index, format: :json, auth_token: @current_user.authentication_token
    assert_response :success

    @current_user.reload

    assert_not_equal time, @current_user.updated_at
    assert_not_equal count, @current_user.sign_in_count
  end

  test 'get #new should not track user' do
    time = @current_user.updated_at
    count = @current_user.sign_in_count

    get :new, format: :json, auth_token: @current_user.authentication_token
    assert_response :success

    @current_user.reload

    assert_equal time, @current_user.updated_at
    assert_equal count, @current_user.sign_in_count

    #assert_no_difference ['@current_user.reload.updated_at', '@current_user.reload.sign_in_count'], "user shouldn't be tracked" do
    #end
  end
end
