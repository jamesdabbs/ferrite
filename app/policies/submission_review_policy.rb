class SubmissionReviewPolicy < ApplicationPolicy
  def create?
    user.instructor?
  end

  def update?
    record.reviewer == user
  end
end
