class StaffController < ApplicationController
  def index
    @staff = Employment.all
  end
end
