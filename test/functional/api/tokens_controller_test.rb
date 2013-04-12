require 'test_helper'

class Api::TokensControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test 'authorised user should get a token' do
    mock_user = SimpleMock.new User.new

    mock_user.expect(:ensure_authentication_token!, true)
    mock_user.expect(:authentication_token, 'token')
    mock_user.expect(:email, 'test')
    mock_user.expect(:valid_password?, true, %w(password))


    User.stub :find_for_authentication, mock_user do

      post :create, format: :json, email: 'test', password: 'password'

      assert_response :success, 'should be successful'

      response_data = JSON.parse(response.body)
      assert_equal 'token', response_data['authentication_token']
      assert_equal 'test', response_data['email']

      mock_user.verify
    end

  end

  test 'Non JSON request should return 406' do
    post :create, format: :xml, email: 'test', password: 'test'
    assert_response :not_acceptable
  end

  test 'invalid params should return 400' do
    post :create, format: :json, foo: 'bar'
    assert_response :bad_request
  end

  test 'invalid username should return 401' do
    User.stub :find_for_authentication, nil do
      post :create, format: :json, email: 'wrong_user', password: 'test'
      assert_response :unauthorized
    end
  end

  test 'invalid password should return 401' do
    mock_user = SimpleMock.new User.new
    mock_user.expect(:valid_password?, false, %w(wrong_password))

    User.stub :find_for_authentication, mock_user do
      post :create, format: :json, email: 'user', password: 'wrong_password'
      mock_user.verify
      assert_response :unauthorized
    end
  end
end