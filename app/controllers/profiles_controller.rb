class ProfilesController < ApplicationController
  def show
    @user = current_user
    authorize @user
  end
end
