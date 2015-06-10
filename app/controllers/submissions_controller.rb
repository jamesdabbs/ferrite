class SubmissionsController < ApplicationController

  def index
  end

  def show
    @submission = Submission.find params[:id]
    authorize @submission
    @review = SubmissionReview.new submission: @submission
  end

end
