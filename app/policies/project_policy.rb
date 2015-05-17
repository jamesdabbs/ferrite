class ProjectPolicy < ApplicationPolicy
  def create?
    user.instructor?
  end

  def update?
    user.instructor?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
