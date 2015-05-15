class ProjectPolicy < ApplicationPolicy
  def create?
    user.instructor?
  end

  # Not sure if this is necessary
  def new
    user.instructor?
  end

  def index?
    true
  end

  def edit?
    user.instructor?
  end

  # I think this is taken care of with the edit? function
  def update?
    user.instructor?
  end
end
