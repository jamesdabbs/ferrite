class CoursesController < ApplicationController
  def index
    @courses = policy_scope(Course).includes(:campus, :topic, :instructor)
  end

  def new
    authorize :course, :create?
    @course = current_user.new_course
  end

  def create
    @course = current_user.new_course create_params
    authorize @course

    if @course.save
      redirect_to @course, success: "Course added"
    else
      render :new
    end
  end

  def show
    @course = Course.find params[:id]
    authorize @course
    @assignments      = @course.assignments.order(due_at: :desc).includes :project
    @submission_table = SubmissionTable.new policy_scope(@course.submissions)
    @memberships      = @course.memberships.includes user: :identities
  end

  def edit
    @course = Course.find params[:id]
    authorize @course
  end

  def update
    @course = Course.find params[:id]
    authorize @course
    if @course.update update_params
      redirect_to @course, success: "Course updated"
    else
      render :edit
    end
  end

  def sync
    course = Course.find params[:id]
    authorize course
    sync = GithubSync.new current_user.github_client
    sync.pull_course_members course
    redirect_to :back, notice: "Sync'd members from Github"
  end

private

  def create_params
    params.require(:course).permit :campus_id, :topic_id, :start_on, :organization
  end

  def update_params
    params.require(:course).permit :start_on, :organization, :slack_team_id, :slack_room
  end
end
