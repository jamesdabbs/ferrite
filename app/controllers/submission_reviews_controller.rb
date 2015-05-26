class SubmissionReviewsController < ApplicationController
  def new
    @submission_review = SubmissionReview.new
  end

  def create
    @submission = Submission.find params[:submission_id]
    @submission_review = @submission.reviews.new create_params
    @submission_review.reviewer = current_user
    authorize @submission_review
    if @submission_review.save
      @submission.assignment.course.notify_of_new_review @submission
      redirect_to @submission, notice: "Review saved!"
    else
      redirect_to @submission, alert: "Review not saved - #{@submission_review.errors.full_messages.to_sentence}"
    end
  end

  def show
    @submission_review = SubmissionReview.find params[:id]
    @submission = @submission_review.find params[:submission_id]
  end

  def edit
    # FIXME: this is too coupled. Initial review create should probably be
    #   on this controller at least
    @review = SubmissionReview.find params[:id]
    authorize @review
    @submission = @review.submission
    render template: "submissions/show"
  end

  def update
    review = SubmissionReview.find params[:id]
    authorize review
    if review.update update_params
      redirect_to review.submission, notice: "Review updated!"
    else
      redirect_to review.submission, alert: "Review not updated - #{review.errors.full_messages.to_sentence}"
    end
  end

private

  def create_params
    params.require(:submission_review).permit(:score, :general_comments)
  end

  def update_params
    create_params
  end
end
