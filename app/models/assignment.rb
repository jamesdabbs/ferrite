class Assignment < ActiveRecord::Base
  belongs_to :project
  belongs_to :course

  has_many :submissions

  validates_presence_of :project, :course

  def self.tomorrow_at hour, zone=nil
    zone ||= Rails.application.config.time_zone
    tomorrow = DateTime.now + 1.day
    tomorrow.in_time_zone(zone).change hour: hour, minute: 0, second: 0
  end

  def title
    project.title
  end

  def admin_label
    # we won't have a project when new'ing
    project.try :title
  end
end
