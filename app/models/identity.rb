class Identity < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user, :provider, :uid, :data
  validates_uniqueness_of :provider, scope: :user
  validates_uniqueness_of :uid, scope: :provider

  def username
    case provider
    when "github"
      data["info"]["nickname"]
    when "google_oauth2"
      data["info"]["email"]
    else
      raise "Unknown Provider: #{provider}"
    end
  end
end
