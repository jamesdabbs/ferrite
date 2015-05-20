class SubmissionReviewsController < ApplicationController
  def new
    @submissionreview = SubmissionReview.new
  end
  
  def create
    @submission = Submission.find params[:submission_id]
    @submissionreview = @submission.reviews.new(create_params)
    @submissionreview.reviewer = current_user
    # Comments expects to be a json field, needs to be an object
    @submissionreview.comments = {"general" => create_params[:comments]}
    authorize @submissionreview
    if @submissionreview.save
      redirect_to @submission, notice: "Review saved!"
    else
      redirect_to @submission, alert: "Review not saved."
    end
  end

  def show
    @submissionreview = SubmissionReview.find params[:id]
    @submission = @submissionreview.find params[:submission_id]
    
  end

private
  def create_params
    params.require(:submission_review).permit :submission_id, :score, :comments
  end
end