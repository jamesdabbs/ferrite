class ProjectsController < ApplicationController
  def index
    @projects = policy_scope(Project) #.order created_at: :desc
  end

  def new
    authorize :project, :create?
    @project = Project.new
  end

  def create
    @topic   = Topic.find create_params[:topic_id]
    @project = @topic.projects.new create_params
    authorize @project

    if @project.save
      redirect_to @project, notice: "Project created."
    else
      render :new, alert: "Unable to save project."
    end
  end

  def edit
    @project = Project.find params[:id]
    authorize @project
  end

  def update
    @project = Project.find params[:id]
    authorize @project
    redirect_to @project
  end

  def show
    @project = Project.find params[:id]
    @assignment = @project.assignments.new
    @assignment.due_at = Assignment.tomorrow_at 2, current_user.time_zone
    authorize @project
  end

private

  def create_params
    params.require(:project).permit(:topic_id, :title, :description)
  end
end

