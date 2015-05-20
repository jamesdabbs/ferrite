class Assignment < ActiveRecord::Base
  belongs_to :project
  belongs_to :course

  validates_presence_of :project, :course

  def admin_label
    project.try :title
  end
end
