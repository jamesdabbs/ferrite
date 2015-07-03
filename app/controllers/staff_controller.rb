class StaffController < ApplicationController
  def index
    @staff = policy_scope(Employment).
      order(last_name: :asc).
      includes(:campus, :current_course).
      select(&:active?)
  end

  def edit
    authorize :employment
    @campuses = Campus.all
    @courses  = Course.all.includes(:campus, :topic).to_a
    @staff = policy_scope(Employment).
      order(last_name: :asc).
      includes(:campus, current_course: :topic).
      select(&:active?)
  end

  def update
    authorize :employment

    employments = Employment.all.map { |e| [e.id, e] }.to_h

    campuses = params[:campus].select { |employment_id, campus_id| campus_id.present? }
    campuses.each do |employment_id, campus_id|
      employment = employments.fetch employment_id.to_i
      unless employment.campus_id == campus_id.to_i
        employment.update! campus_id: campus_id
      end
    end

    courses = params[:course].select { |employment_id, course_id| course_id.present? }
    courses.each do |employment_id, course_id|
      employment = employments.fetch employment_id.to_i
      unless employment.current_course_id == course_id.to_i
        employment.update! current_course_id: course_id
      end
    end

    redirect_to :back, notice: "Updated!"
  end
end
