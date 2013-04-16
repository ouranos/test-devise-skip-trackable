class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
  def skip_trackable
    request.env['devise.skip_trackable'] = true
  end
end
