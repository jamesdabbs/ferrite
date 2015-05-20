class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  include Pundit
  after_action :verify_authorized, except: :index, if: :user_space?
  after_action :verify_policy_scoped, only: :index, if: :user_space?

  rescue_from GH::NotAuthorized do |e|
    session[:_after_github_auth_redirect_path] = request.path
    redirect_to user_omniauth_authorize_path(:github)
  end

  def user_space?
    return false if devise_controller?
    return false if self.class.name.start_with? "RailsAdmin::" # yuck
    return true
  end
end
