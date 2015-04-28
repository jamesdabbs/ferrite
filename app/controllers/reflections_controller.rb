class ReflectionsController < ApplicationController
  before_action do
    @course     = Course.find params[:course_id]
    @reflection = @course.reflection_for params[:week_number], params[:reflection]
  end

  def edit
  end

  def update
  end
end
