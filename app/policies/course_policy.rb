class CoursePolicy < ApplicationPolicy
  def create?
    user.instructor?
  end

  def update?
    record.instructor.user == user
  end

  def sync?
    update?
  end

  def random_pick?
    user.instructor?
  end

end
