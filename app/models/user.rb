class User < ActiveRecord::Base
  devise :rememberable, :trackable, :omniauthable,
    omniauth_providers: [:google_oauth2, :github]

  has_many :identities
  has_one :employment

  def instructor?
    employment.present?
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

  def new_course opts={}
    employment.new_course opts
  end
end
