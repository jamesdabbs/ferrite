class Employment < ActiveRecord::Base
  belongs_to :user
  belongs_to :campus
  belongs_to :topic
  belongs_to :current_course, class_name: "Course"

  has_many :courses, foreign_key: :instructor_id

  validates :email, presence: true, uniqueness: true

  def self.pull_all!
    pull_from_slack!
    pull_from_teamwork!
  end

  def self.pull_from_slack!
    SlackApi.new.user_data.each do |d|
      p = d["profile"]
      email = p.fetch("email").downcase

      e = where(email: email).first_or_initialize
      e.first_name ||= p.fetch("first_name", "")
      e.last_name  ||= p.fetch("last_name",  "")
      e.slack_data   = d

      e.ensure_user!
      e.save!
    end
  end

  # TODO: reconcile this with the previous Teamwork::Sync now that Teamwork
  #   isn't the primary source of employment data
  def self.pull_from_teamwork!
    Teamwork::Client.new.authors.each do |a|
      email = a.fetch("email-address").downcase
      next unless email.present?

      e = where(email: email).first_or_initialize
      e.first_name  ||= a.fetch("first-name", "")
      e.last_name   ||= a.fetch("last-name",  "")
      e.teamwork_data = a

      e.ensure_user!
      e.save!
    end
  end

  def ensure_user!
    self.user ||= User.where(email: email).first_or_create! do |u|
      u.name = name
    end
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def new_course opts={}
    next_monday = Date.today.at_beginning_of_week + 1.week
    defaults = {
      campus:   campus,
      topic:    topic,
      start_on: next_monday
    }
    courses.new defaults.merge opts
  end

  def title
    slack_data["profile"]["title"] || teamwork_data["title"]
  end

  def slack_username
    slack_data["name"]
  end

  def phone_number
    slack_data["profile"]["phone"]
  end

  def skype_username
    slack_data["profile"]["skype"]
  end

  def slack_avatar size
    slack_data["profile"].fetch("image_#{size}")
  end

  def active?
    !slack_data["deleted"]
  end

  def admin_label
    name
  end
end
