class SubmissionReviewsController < ApplicationController
  def new
    @submission_review = SubmissionReview.new
  end

  def create
    @submission = Submission.find params[:submission_id]
    @submission_review = @submission.reviews.new(create_params)
    @submission_review.reviewer = current_user
    # Comments expects to be a json field, needs to be an object
    @submission_review.comments = {"general" => create_params[:comments]}
    authorize @submission_review
    if @submission_review.save
      redirect_to @submission, notice: "Review saved!"
    else
      redirect_to @submission, alert: "Review not saved - #{@submission_review.errors.full_messages.to_sentence}"
    end
  end

  def show
    @submission_review = SubmissionReview.find params[:id]
    @submission = @submission_review.find params[:submission_id]
  end

private

  def create_params
    params.require(:submission_review).permit :submission_id, :score, :comments
  end
end
