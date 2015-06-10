class SubmissionReviewPolicy < ApplicationPolicy
  def create?
    user.instructor? || user.assists_with?(record.submission)
  end

  def update?
    record.reviewer == user
  end
end
