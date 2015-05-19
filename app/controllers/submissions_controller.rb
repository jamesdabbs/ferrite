class SubmissionsController < ApplicationController
  
  def index
  end

  def show
    @submission = Submission.find params[:id]
    @submissionsreviews = @submission.reviews.all
    authorize @submission
  end

end