class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    user = GoogleOauth.new(auth_data).find_or_register!
    sign_in user
    redirect_to courses_path
  rescue GoogleOauth::InvalidDomain => e
    redirect_to root_path, alert: e.message
  end

  def github
    if user_signed_in?
      # TODO: do we care if this is staff or student?
      current_user.link_github_account auth_data
    else
      user = GithubOauth.new(auth_data).find_or_register!
      sign_in user
    end

    destination   = session.delete(:_after_github_auth_redirect_path)
    destination ||= current_user.instructor? ? courses_path : assignments_path
    # ^Changed user to current_user because User was showing up as NIL

    redirect_to destination
  end

private

  def auth_data
    request.env["omniauth.auth"]
  end

  def after_omniauth_failure_path_for scope
    sign_in_path
  end
end
