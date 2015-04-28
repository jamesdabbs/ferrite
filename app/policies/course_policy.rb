class CoursePolicy < ApplicationPolicy
  def create?
    user.instructor?
  end
end
