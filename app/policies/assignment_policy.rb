class AssignmentPolicy < ApplicationPolicy

  def show?
    true
  end

  def create?
    user.instructor?
  end

  class Scope < Scope
    def resolve
      scope.where(course: user.active_course)
    end
  end
end
