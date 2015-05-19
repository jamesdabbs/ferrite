class SubmissionReviewsController < ApplicationController
  def create
    @submission = Submission.find create_params[:submission_id]
    @submissionreview = @Submission.submissionreviews.new(create_params)
  end

  def show
    @submissionreview = SubmissionReview.find params[:id]
    @submission = @submissionreview.find params[:submission_id]
    authorize @submissionreview
      if @submissionreview.save
        redirect_to @submission, notice: "Review saved!"
      else
        redirect_to @submission, alert: "Review not saved."
      end
  end

private
  def create_params
    params.require(:submissionreview).permit :submission_id, :reviewer_id, :score, :comments
  end
end