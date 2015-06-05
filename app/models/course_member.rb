class CourseMember < ActiveRecord::Base
  Roles = %w( student assistant instructor )

  scope :students, -> { where(role: "student") }

  belongs_to :course
  belongs_to :user

  validates_presence_of :course, :user, :role
  validates_inclusion_of :role, in: Roles
end
