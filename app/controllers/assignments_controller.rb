class AssignmentsController < ApplicationController
  def index
    @assignments = policy_scope(Assignment).order(created_at: :desc).includes :project, :submissions
  end

  def new
    @assignment = Assignment.new
  end

  def create
    @project = Project.find params[:project_id]
    @assignment = @project.assignments.new(assignment_params)
    authorize @assignment
    if @assignment.save
      @assignment.course.notify_of_new_assignment @assignment
      redirect_to @assignment, notice: "Assignment created."
    else
      redirect_to @project
    end
  end

  def show
    # TODO: clean up duplication between here and submit action
    @assignment = Assignment.find params[:id]
    authorize @assignment
    @submissions = policy_scope(@assignment.submissions)
    @submission  = @submissions.new
  end

  def submit
    # TODO: should this be submissions#new ?
    @assignment  = Assignment.find params[:id]
    @submissions = current_user.submissions_for @assignment
    @submission  = @submissions.new submission_params
    authorize @submission, :create?

    if @submission.save
      @submission.note_current_commit current_user.github_client
      @assignment.course.notify_of_submission @submission
      redirect_to @assignment
    else
      render :show
    end
  end

private

  def assignment_params
    params.require(:assignment).permit :course_id, :due_at
  end

  def submission_params
    params.require(:submission).permit :comments, :comfort, :repo, :hours_spent
  end
end
