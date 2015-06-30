class User < ActiveRecord::Base
  def self.time_zones
    ActiveSupport::TimeZone.us_zones
  end

  devise :rememberable, :trackable, :omniauthable,
    omniauth_providers: [:google_oauth2, :github]

  validates :email, presence: true, uniqueness: true
  validates :time_zone, presence: true, inclusion: { in: time_zones.map(&:name) }

  has_many :identities
  has_one :employment

  has_many :submissions
  has_many :submission_reviews, foreign_key: "reviewer_id"

  belongs_to :active_course, class_name: "Course"

  has_many :memberships, class_name: "CourseMember"
  has_many :courses, through: :memberships

  has_many :slack_team_memberships, class_name: "Slack::TeamMembership"
  has_many :slack_teams, through: :slack_team_memberships, source: :team

  def self.from_github_identities uids
    identities = Identity.where(provider: "github", uid: uids).includes :user
    identities.map &:user
  end

  def instructor?
    employment.present?
  end
  # TODO: these probably need to be finer grained
  def admin?
    instructor?
  end
  def student?
    !instructor?
  end

  def link_github_account auth
    identity = identities.where(provider: 'github').first_or_initialize
    identity.update uid: auth.uid, data: auth.to_h
    identity
  end

  def github_account_url
    "//github.com/#{github_username}"
  end

  def github_client
    @_github_client ||= begin
      identity = identities.where(provider: 'github').first!
      Octokit::Client.new access_token: identity.data["credentials"]["token"]
    rescue ActiveRecord::RecordNotFound => e
      # FIXME: need a better way to inject this
      if Rails.env.test?
        Octokit::Client.new
      else
        raise GH::NotAuthorized, "No linked Github account"
      end
    end
  end

  def github_organizations
    @_github_organizations ||= github_client.organizations
  end
  def recent_repos
    @_recent_repos ||= github_client.repos(github_username, sort: :pushed, direction: :desc)
  end

  def new_course opts={}
    employment.new_course opts
  end

  def submissions_for assignment
    submissions.where(assignment: assignment).order(created_at: :desc)
  end

  def admin_label
    email
  end

  def assisted_course_ids
    @_assisted_course_ids ||= memberships.where(role: "assistant").pluck(:course_id)
  end

  def assists_with? submission
    assisted_course_ids.include? submission.assignment.course_id
  end
end
