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
    assert_no_difference ['@current_user.reload.sign_in_count'], "user shouldn't be tracked" do
      get :new, format: :json, auth_token: @current_user.authentication_token
    end

    assert_response :success
    assert_nil @current_user.last_sign_in_at
    assert_nil @current_user.current_sign_in_at
  end
end
