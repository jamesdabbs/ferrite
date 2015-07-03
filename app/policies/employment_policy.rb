class EmploymentPolicy < ApplicationPolicy
  def update?
    # Should a user be allowed to edit their own employment?
    user.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
