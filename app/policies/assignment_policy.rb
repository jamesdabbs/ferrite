class AssignmentPolicy < ApplicationPolicy

  def index?
    true
  end
  # ^Trying this to figure out what I can't view assignment in index table...
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
