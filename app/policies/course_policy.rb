class CoursePolicy < ApplicationPolicy
  def create?
    user.instructor?
  end

  def sync?
    user.instructor?
  end
end
