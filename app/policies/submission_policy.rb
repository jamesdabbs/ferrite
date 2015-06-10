class SubmissionPolicy < ApplicationPolicy
  def create?
    record.user == user
  end

  def show?
    record.user == user ||
    user.instructor?    ||
    user.assists_with?(record)
    # or the record marked as public?
  end

  class Scope < Scope
    def resolve
      if user.instructor?
        scope.all
      elsif user.assisted_course_ids.any?
        scope.includes(:assignment).where(assignments: { course_id: user.assisted_course_ids })
      else
        scope.where(user: user)
      end
    end
  end
end
