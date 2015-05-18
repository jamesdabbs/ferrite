class SubmissionPolicy < ApplicationPolicy
  def create?
    record.user == user
  end
end
