class StaffController < ApplicationController
  def index
    @staff = policy_scope(Employment.order last_name: :asc).
      includes(:campus, :current_course).
      select(&:active?)
  end
end
