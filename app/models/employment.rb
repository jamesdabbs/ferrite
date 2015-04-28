class Employment < ActiveRecord::Base
  belongs_to :user
  belongs_to :campus
  belongs_to :topic

  has_many :courses, foreign_key: :instructor_id

  def name
    "#{first_name} #{last_name}".strip
  end

  def new_course opts={}
    next_monday = Date.today.at_beginning_of_week + 1.week
    courses.new opts.merge(
      campus:   campus,
      topic:    topic,
      start_on: next_monday
    )
  end
end
