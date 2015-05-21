class SubmissionPolicy < ApplicationPolicy
  def create?
    record.user == user
  end

  def show?
    record.user == user || user.instructor? #or the record marked as public
  end

  class Scope < Scope
    def resolve
      if user.instructor?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end
end
