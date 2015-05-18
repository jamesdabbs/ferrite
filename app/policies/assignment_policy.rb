class AssignmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(course: user.active_course)
    end
  end
end
