class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :login
  skip_after_action :verify_authorized, only: [:home, :login]

  def home
  end

  def login
  end
end
