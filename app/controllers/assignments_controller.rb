class AssignmentsController < ApplicationController
  def index
    @assignments = policy_scope(Assignment).includes :project
  end

  def show
    # TODO: clean up duplication between here and submit action
    @assignment = Assignment.find params[:id]
    authorize @assignment
    if current_user.instructor?
      @submissions = @assignment.submissions
    else
      @submissions = current_user.submissions_for @assignment
      @submission  = @submissions.new
    end
  end

  def submit
    # TODO: should this be submissions#new ?
    @assignment  = Assignment.find params[:id]
    @submissions = current_user.submissions_for @assignment
    @submission  = @submissions.new submission_params
    authorize @submission, :create?

    if @submission.save
      @submission.note_current_commit current_user.github_client
      redirect_to @assignment
    else
      render :show
    end
  end

private

  def submission_params
    params.require(:submission).permit :comments, :comfort, :repo, :hours_spent
  end
end
