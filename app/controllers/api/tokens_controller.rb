class Api::TokensController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :ensure_params_present

  respond_to :json

  def create
    resource = User.find_for_database_authentication(email: params[:email])
    return invalid_login_attempt unless resource

    resource.ensure_authentication_token! # Make sure we have an authentication token

    return invalid_login_attempt unless resource.valid_password?(params[:password])

    respond_to do |format|
      format.json {
        render :json => {:success => true, :authentication_token => resource.authentication_token, :email => resource.email}
      }
    end

  end

  protected
  def ensure_params_present
    return if params[:email].present? && params[:password].present?
    respond_to do |format|
      format.json {
        render :json => {:success => false, :message => 'Missing email or password'}, :status => :bad_request
      }
    end
  end

  def invalid_login_attempt
    warden.custom_failure!

    respond_to do |format|
      format.json {
        render :json => {:success => false, :message => 'Invalid email or password'}, :status => :unauthorized
      }
    end
  end
end