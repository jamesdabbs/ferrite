class Course < ActiveRecord::Base
  belongs_to :campus
  belongs_to :topic
  belongs_to :instructor, class_name: "Employment"

  validates_presence_of :campus, :topic, :instructor, :start_on, :organization

  # TODO: validate JSON data structure
  #validate def check_json_data_schema
  #  errors.add :data, "is malformed"
  #end
  after_initialize do
    self.reflections ||= {}
  end

  def weeks
    1.upto(12).map { |n| Week.new self, n }
  end

  def github_org
    Github::Organization.new organization if organization
  end
end
