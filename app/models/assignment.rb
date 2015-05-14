class Assignment < ActiveRecord::Base
  belongs_to :project
  belongs_to :course

  validates_presence_of :project, :course
end
