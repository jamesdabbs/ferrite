require 'test_helper'

class GoogleOauthTest < ActiveSupport::TestCase
  def auth extras={}
    Hashie::Mash.new({
      provider: "google_oauth2",
      uid:      "1",
      info: {
        email:      "james+oauthtest@theironyard.com",
        first_name: "James",
        last_name:  "Dabbs",
        name:       "James Dabbs"
      },
      extra: {
        favorite_movie: "Alien"
      }
    }).merge extras
  end

  def test_it_checks_domains
    assert_raises GoogleOauth::InvalidDomain do
      GoogleOauth.new(auth info: { email: "jamesdabbs@gmail.com" }).find_or_register!
    end
  end

  def test_it_finds_existing_users
    existing = User.first
    found    = GoogleOauth.new(auth info: { email: existing.email }).find_or_register!
    assert_equal existing, found
  end

  def test_it_creates_new_employed_users
    email = auth.info.email
    assert_nil User.find_by_email email

    user = GoogleOauth.new(auth).find_or_register!

    assert_equal user, User.find_by_email(email)
    assert user.employment
  end
end
