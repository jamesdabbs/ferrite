class AuthTokenPolicy < ApplicationPolicy
  def create?
    record.user == user
  end
  def destroy?
    record.user == user
  end
end
