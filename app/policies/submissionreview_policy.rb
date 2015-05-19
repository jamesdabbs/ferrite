class SubmissionReviewPolicy < ApplicationPolicy
  def create?
    user.instructor?
  end
end
