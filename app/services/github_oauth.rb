class GithubOauth
  attr_reader :auth

  def initialize auth
    @auth = auth
    freeze
  end

  def find_or_register!
    identity = find_or_initialize_identity
    ensure_user identity
    identity.user
  end

private

  # TODO: de-dup w/ google oauth
  def find_or_initialize_identity
    Identity.where(provider: auth.provider, uid: auth.uid).first_or_initialize do |i|
      i.data = auth.to_h
    end
  end
  def ensure_user identity
    return if identity.user
    user = User.where(email: auth.info.email).first_or_create! do |u|
      u.name = auth.info.name.blank? ? auth.info.nickname : auth.info.name
      u.github_username = auth.info.nickname
    end
    identity.update! user: user
  end
end
