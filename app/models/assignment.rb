class Assignment < ActiveRecord::Base
  belongs_to :project
  belongs_to :course

  has_many :submissions

  validates_presence_of :project, :course

  def title
    project.title
  end

  def admin_label
    title
  end
end
