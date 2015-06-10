class Course < ActiveRecord::Base
  belongs_to :campus
  belongs_to :topic
  belongs_to :instructor, class_name: "Employment"

  has_many :assignments
  has_many :submissions, through: :assignments

  has_many :memberships, class_name: "CourseMember"
  has_many :members, through: :memberships, source: :user

  has_many :student_memberships, -> { students }, class_name: "CourseMember"
  has_many :students, through: :student_memberships, source: :user

  belongs_to :slack_team, class_name: "Slack::Team"

  validates_presence_of :campus, :topic, :instructor, :start_on, :organization
  validates_uniqueness_of :organization

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
    GH::Organization.new organization if organization
  end

  def admin_label
    organization
  end

  def ensure_users_are_members users
    users.each do |user|
      memberships.where(user: user).first_or_create! do |m|
        m.role = "student"
      end
    end
  end

  # TODO: extract these vvv
  def notify_of_submission submission
    return unless slack_team

    membership     = slack_team.membership_for instructor.user
    submission_url = Rails.application.routes.url_helpers.submission_url submission

    message = Slack::Message.new(
      to:   membership,
      body: "New submission for #{submission.assignment.title} by #{submission.user.name} - visit #{submission_url} to review"
    )
    message.deliver
  end

  def notify_of_new_assignment assignment
    return unless slack_team

    url     = Rails.application.routes.url_helpers.assignment_url assignment
    message = Slack::Message.new(
      to:   self,
      body: "New assignment posted @ #{url} | #{assignment.project.title}"
    )
    message.deliver
  end

  def notify_of_new_review submission
    return unless slack_team

    membership = begin
      slack_team.membership_for submission.user
    rescue ActiveRecord::RecordNotFound => e
      return false
    end

    url     = Rails.application.routes.url_helpers.submission_url submission
    message = Slack::Message.new(
      to:   membership,
      body: "New review of #{submission.assignment.project.title} posted @ #{url}"
    )
    message.deliver
  end

  def pick_member
    # TODO Refactor
    unless student_memberships.empty?
      pick_min = student_memberships.minimum(:picks)
      chosen_course_member = student_memberships.where(picks: pick_min).random
      chosen_course_member.picks += 1
      chosen_course_member.save
      chosen_course_member.user
    end
  end
end
