class GoogleOauth
  class Error < StandardError; end
  class InvalidDomain < Error; end

  attr_reader :auth, :domain

  def initialize auth
    @auth   = auth
    @domain = Figaro.env.required_login_domain || "theironyard.com"
    freeze
  end

  def find_or_register!
    check_provider
    check_domain
    identity = find_or_initialize_identity
    ensure_user identity
    ensure_employment identity.user
    identity.user
  end

private

  def check_provider
    unless auth.provider == "google_oauth2"
      raise Error, "expected google_oauth2 data, not #{auth.provider}"
    end
  end

  def check_domain
    unless auth.info.email.ends_with? domain
      raise InvalidDomain, "You must sign in with a #{domain} address"
    end
  end

  def find_or_initialize_identity
    Identity.where(provider: auth.provider, uid: auth.uid).first_or_initialize do |i|
      i.data = auth.to_h
    end
  end

  def ensure_user identity
    return if identity.user
    user = User.where(email: auth.info.email).first_or_create!
    identity.update! user: user
  end

  def ensure_employment user
    return if user.employment
    e = Employment.where(email: user.email).first_or_initialize
    e.update(
      user:       user,
      first_name: auth.info.first_name,
      last_name:  auth.info.last_name
    )
  end
end
