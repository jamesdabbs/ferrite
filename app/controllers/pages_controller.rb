class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :login
  skip_after_action :verify_authorized, only: [:home, :login]

  def home
  end

  def login
    if course = current_user.try(:active_course)
      redirect_to course
    end
  end
end
