class SubmissionPolicy < ApplicationPolicy
  def create?
    record.user == user
  end

  def show?
    record.user == user || user.instructor? #or the record marked as public
  end
end
