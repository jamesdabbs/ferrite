class User < ActiveRecord::Base
  devise :rememberable, :trackable, :omniauthable,
    omniauth_providers: [:google_oauth2, :github]

  validates :email, presence: true, uniqueness: true

  has_many :identities
  has_one :employment

  has_many :submissions
  has_many :submission_reviews

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

  def github_client
    @_github_client ||= begin
      identity = identities.where(provider: 'github').first!
      Octokit::Client.new access_token: identity.data["credentials"]["token"]
    rescue ActiveRecord::RecordNotFound => e
      raise Github::NotAuthorized, "No linked Github account"
    end
  end

  def github_organizations
    @_github_organizations ||= github_client.organizations
  end
  def recent_repos
    @_recent_repos ||= github_client.repos(nil, sort: :pushed, direction: :desc)
  end

  def new_course opts={}
    employment.new_course opts
  end

  def active_course
    # FIXME: what about users in multiple courses?
    @_active_course ||= Course.
      where(organization: github_organizations.map(&:login)).
      order(start_on: :desc).
      first
  end

  def submissions_for assignment
    submissions.where(assignment: assignment).order(created_at: :desc)
  end

  def admin_label
    email
  end
end
